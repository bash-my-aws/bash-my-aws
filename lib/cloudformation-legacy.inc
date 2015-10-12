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
