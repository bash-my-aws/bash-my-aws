# cloudformation.inc

source $(dirname ${BASH_SOURCE[0]})/shared.inc

stack() {
  # TODO: allow filtering for resources
  # type: query
  # returns instance id's and the name tag.
  local inputs=$(__bma_read_inputs $@)

  if __bma_read_switches ${inputs} | grep ^--debug > /dev/null; then
    BMA_DEBUG=true
  else
    BMA_DEBUG=false
  fi

  local default_query='
    StackSummaries[][
      {
        "StackName": StackName
      }
    ][]
  '

  local stack_ids=$(__bma_read_resources $inputs)
  local filters=$(__bma_read_switches $inputs | grep ^--filters | cut -d\  -f2-)
  local query=$(__bma_read_switches $inputs | grep ^--query | cut -d\  -f2-)
  local output=$(__bma_read_switches $inputs | grep ^--output | cut -d\  -f2-)

  if ${BMA_DEBUG}; then
    echo "inputs: ${inputs}"
    echo "instance_ids: ${instance_ids}"
    echo "filters: ${filters}"
    echo "query: ${query}"
    echo "output: ${output}"
  fi

  [[ -z $query ]] && local query=$default_query

  grep_filter=""
  for stack in ${stack_ids}; do
    grep_filter="-e ${stack} "
  done

  aws cloudformation list-stacks                      \
    --stack-status                                    \
      CREATE_COMPLETE                                 \
      CREATE_FAILED                                   \
      CREATE_IN_PROGRESS                              \
      DELETE_FAILED                                   \
      DELETE_IN_PROGRESS                              \
      ROLLBACK_COMPLETE                               \
      ROLLBACK_FAILED                                 \
      ROLLBACK_IN_PROGRESS                            \
      UPDATE_COMPLETE                                 \
      UPDATE_COMPLETE_CLEANUP_IN_PROGRESS             \
      UPDATE_IN_PROGRESS                              \
      UPDATE_ROLLBACK_COMPLETE                        \
      UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS    \
      UPDATE_ROLLBACK_FAILED                          \
      UPDATE_ROLLBACK_IN_PROGRESS                     \
    --query $(__bma_clean_query ${query})             \
    --output ${output:-"text"}                        |
    sort                                              |
    grep --color=never ${grep_filter:-".*"}
}

stack-delete() {
  # XXX: Have this discussion:
  # https://github.com/realestate-com-au/bash-my-aws/issues/19
  local inputs=$(__bma_read_inputs $@)
  local stack=$(__bma_read_resources ${inputs} | awk '{print $1}')

  if [[ -z ${stack} ]]; then
    __bma_error "You need to provide a stack name" || return 1
  fi

  aws cloudformation delete-stack --stack-name $stack
  return $?
}

stack-failure() {
  # FIXME: only grab the latest one
  local inputs=$(__bma_read_inputs $@)
  local stack=$(__bma_read_resources ${inputs} | awk '{print $1}')

  if [[ -z ${stack} ]]; then
    __bma_error "You need to provide a stack name" || return 1
  fi

  local query='
    StackEvents[?contains(ResourceStatus,`FAILED`)].[
      PhysicalResourceId,
      Timestamp,
      ResourceStatusReason
    ]
  '
  local output=$(__bma_read_switches $inputs | grep ^--output | cut -d\  -f2-)

  aws cloudformation describe-stack-events \
    --stack-name ${stack}                  \
    --query $(__bma_clean_query ${query})  \
    --output ${output:-"text"}
}

stack-parameters() {
  local inputs=$(__bma_read_inputs $@)
  local stack=$(__bma_read_resources ${inputs} | awk '{print $1}')

  if [[ -z ${stack} ]]; then
    __bma_error "You need to provide a stack name" || return 1
  fi

  local query='
    Stacks[].Parameters[]
  '
  local output=$(__bma_read_switches $inputs | grep ^--output | cut -d\  -f2-)

  aws cloudformation describe-stacks        \
    --stack-name ${stack}                   \
    --query $(__bma_clean_query ${query})   \
    --output ${output:-"text"}
}

stack-status() {
  ## detail
  local inputs=$(__bma_read_inputs $@)
  local query='
    StackSummaries[][
      [
        StackStatus,
        StackName
      ]
    ][]
  '
  stack ${inputs} --query ${query}
}

stack-template() {
  local inputs=$(__bma_read_inputs $@)

  for stack in $(__bma_read_resources ${inputs}); do
    aws cloudformation get-template   \
      --stack-name ${stack}           \
      --query TemplateBody
  done
}

stack-outputs() {
  local inputs=$(__bma_read_inputs $@)
  local stack=$(__bma_read_resources ${inputs} | awk '{print $1}')

  if [[ -z ${stack} ]]; then
    __bma_error "You need to provide a stack name" || return 1
  fi

  local query='
    Stacks[].Outputs[]
  '
  local output=$(__bma_read_switches $inputs | grep ^--output | cut -d\  -f2-)

  aws cloudformation describe-stacks        \
    --stack-name ${stack}                   \
    --query $(__bma_clean_query ${query})   \
    --output ${output:-"text"}
}

## vim: ft=sh
