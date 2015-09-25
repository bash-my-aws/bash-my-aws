stack() {
  aws cloudformation list-stacks \
    --stack-status  \
      CREATE_COMPLETE \
      CREATE_FAILED \
      CREATE_IN_PROGRESS \
      DELETE_FAILED \
      DELETE_IN_PROGRESS \
      ROLLBACK_COMPLETE \
      ROLLBACK_FAILED \
      ROLLBACK_IN_PROGRESS \
      UPDATE_COMPLETE \
      UPDATE_COMPLETE_CLEANUP_IN_PROGRESS \
      UPDATE_IN_PROGRESS \
      UPDATE_ROLLBACK_COMPLETE \
      UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS \
      UPDATE_ROLLBACK_FAILED \
      UPDATE_ROLLBACK_IN_PROGRESS \
  --query "StackSummaries[].StackName" \
  --output text | tr '\t' '\n' | sort | grep "$1"
}

cf_events() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack"; return 1; fi
  local stack="$(basename $1 .json)"
  shift
  local output
  if output=$(aws cloudformation describe-stack-events --stack-name $stack --query 'sort_by(StackEvents, &Timestamp)[].{Resource: LogicalResourceId, Type: ResourceType, Status: ResourceStatus}' --output table $@); then
    echo "$output" | uniq -u
  else
    return $?
  fi
}

cf_create() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack [template-file] [params-file]"; return 1; fi
  local stack="$(basename $1 .json)"
  local template="$(_cf_template_arg $stack $2)"
  if [ ! -f "$template" ]; then
    echo "Could not find template (${template}). You can specify alternative template as second argument."
    return 1
  fi
  local params="$(_cf_params_arg $stack $template $3)"
  if [ -n "$params" ] ; then local parameters="--parameters file://$params"; fi
  if aws cloudformation create-stack --stack-name $stack --template-body file://$template $parameters --capabilities CAPABILITY_IAM --disable-rollback
  then
    cf_tail $stack
  fi
}

cf_update() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack [template-file] [params-file]"; return 1; fi
  local stack="$(basename $1 .json)"
  local template="$(_cf_template_arg $stack $2)"
  if [ ! -f "$template" ]; then
    echo "Could not find template (${template}). You can specify alternative template as second argument."
    return 1
  fi
  local params="$(_cf_params_arg $stack $template $3)"
  if [ -n "$params" ] ; then local parameters="--parameters file://$params"; fi
  if aws cloudformation update-stack --stack-name $stack --template-body file://$template $parameters --capabilities CAPABILITY_IAM
  then
    cf_tail $stack
  fi
}

cf_resources() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack"; return 1; fi
  local stack="$(basename $1 .json)"
  shift
  local query="StackResources[].{LogicalResourceId: LogicalResourceId, PhysicalResourceId: PhysicalResourceId}"
  aws cloudformation describe-stack-resources \
    --stack-name $stack                       \
    --query "$query"                          \
    --output text $@                          |
      tr '\t' ' '                             |
      awk '{ print $2, $1 }'
}

cf_validate() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME cf-template-file"; return 1; fi
  aws cloudformation validate-template --template-body file://$1
}

##
## Functions to work with stack resources
##

cf_asg() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack"; return 1; fi
  local stack="$(basename $1 .json)"
  aws cloudformation describe-stack-resources --stack-name $stack --query "StackResources[?ResourceType==\`AWS::AutoScaling::AutoScalingGroup\`].PhysicalResourceId" --output text
}

cf_asg_instances() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack"; return 1; fi
  local stack="$(basename $1 .json)"
  local instance_ids="$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$(cf_asg $stack)" --query "AutoScalingGroups[].Instances[].[InstanceId]" --output text)"
  instances $instance_ids
}

cf_asg_instance_ssh() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack [user]"; return 1; fi
  local stack="$(basename $1 .json)"

  # local user=$2
  # local instance_id="$(cf_asg_instances $stack | head -1 | cut -f 3)"
  # instance_ssh $instance_id $user # This requires that instance-functions have been loaded
                                    # I'll introduce it shortly as default
                                    # To use in the meantime uncomment this and comment
                                    # out the next three lines

  local user=${2:-${AWS_DEFAULT_USER:-$USER}}
  local instance_ip="$(cf_asg_instances $stack | head -1 | cut -f 1)"
  ssh ${user}@${instance_ip}
}

cf_elbs() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack"; return 1; fi
  local stack="$(basename $1 .json)"
  shift
  local elb_names=$(aws cloudformation describe-stack-resources --stack-name $stack --query 'StackResources[?ResourceType==`AWS::ElasticLoadBalancing::LoadBalancer`].[PhysicalResourceId]' --output text)
  if [ -n "$elb_names" ]; then
    aws elb describe-load-balancers --load-balancer-names $elb_names --query 'LoadBalancerDescriptions[].[LoadBalancerName, DNSName]' --output text
  else
    echo "No load balancers found for CloudFormation stack $stack" >&2
  fi
}


cf_diff() {
  cf_diff_template $@
  echo
  cf_diff_params $@
}

# Report on what changes would be made to stack by applying template
#
# Requires jq-1.4 or later # http://stedolan.github.io/jq/download/
#
cf_diff_template() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack [template]"; return 1; fi
  local stack="$(basename $1 .json)"
  if ! aws cloudformation describe-stacks --stack-name $stack 1>/dev/null; then 
    return 1; 
  fi
  local template="$(_cf_template_arg $stack $2)"
  if [ ! -f "$template" ]; then
    echo "Could not find template (${template}). You can specify alternative template as second argument." >&2
    return 1
  fi
  if [ "x$( type -P colordiff )" != "x" ]; then
    local DIFF_CMD=colordiff
  else
    local DIFF_CMD=diff
  fi
  $DIFF_CMD -u --label stack <(aws cloudformation get-template  --stack-name $stack --query TemplateBody | jq --sort-keys .) --label $template <(jq --sort-keys . $template) 
  if [ $? -eq 0 ]; then
    echo "template for stack ($stack) and contents of file ($template) are the same" >&2
  fi
}

# Report on what changes would be made to stack by applying params
#
# Requires jq-1.4 or later # http://stedolan.github.io/jq/download/
#
cf_diff_params() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack [template]"; return 1; fi
  local stack="$(basename $1 .json)"
  if ! aws cloudformation describe-stacks --stack-name $stack 1>/dev/null; then 
    return 1; 
  fi
  local template="$(_cf_template_arg $stack $2)"
  if [ ! -f "$template" ]; then
    echo "Could not find template (${template}). You can specify alternative template as second argument." >&2
    return 1
  fi
  local params="$(_cf_params_arg $stack $template $3)"
  if [ -z "$params" ]; then
    echo "No params file provided. Skipping" >&2
    return 0
  fi
  if [ ! -f "$params" ]; then
    return 1
  fi
  if [ "x$( type -P colordiff )" != "x" ]; then
    local DIFF_CMD=colordiff
  else
    local DIFF_CMD=diff
  fi
  $DIFF_CMD -u --label params <(aws cloudformation describe-stacks --query "Stacks[].Parameters[]" --stack-name $stack | jq --sort-keys . | jp.py 'sort_by(@,&ParameterKey)') --label $params <(jq --sort-keys . $params | jp.py 'sort_by(@,&ParameterKey)' );
  if [ $? -eq 0 ]; then
    echo "params for stack ($stack) and contents of file ($params) are the same" >&2
  fi
}

# Show all events for CF stack until update completes or fails.
cf_tail() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack"; return 1; fi
  local stack="$(basename $1 .json)"
  local current
  local final_line
  local output
  local previous
  until echo "$current" | tail -1 | egrep -q "${stack}.*_(COMPLETE|FAILED)"
  do
    if ! output=$(cf_events $stack); then
      # Something went wrong with cf_events (like stack not known)
      return 1
    fi
    if [ -z "$output" ]; then sleep 1; continue; fi

    current=$(echo "$output" | sed '$d')
    final_line=$(echo "$output" | tail -1)
    if [ -z "$previous" ]; then
      echo "$current"
    elif [ "$current" != "$previous" ]; then
      comm -13 <(echo "$previous") <(echo "$current")
    fi
    previous="$current"
    sleep 1
  done
  echo $final_line
}

# determine name of template to use
_cf_template_arg() {
  local stack="$(basename $1 .json)"
  local template=$2
  if [ -z "$template" ]; then
    if [ -f "${stack}.json" ]; then
      template="${stack}.json"
    elif [ -f "${stack%-*}.json" ]; then
      template="${stack%-*}.json"
    fi
  fi
  echo $template
}

_cf_params_arg() {
  local stack="$(basename $1 .json)"
  local template=$2
  local params=${3:-$(echo $stack | sed "s/\($(basename $template .json)\)-\([^-][^-]*\)/\1-params-\2.json/")};
  if [ -f "${params}" ]; then
    echo $params
  fi
}
