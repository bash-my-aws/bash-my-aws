# cloudformation.inc

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

stack-status() {
  ## detail
  local inputs=$(__bma_read_inputs $@ | base64 -D)
  local query='
    StackSummaries[][
      {
        "Name": StackName,
        "Status": StackStatus
      }
    ][]
  '
  stack ${inputs} --query ${query}
}


## vim: ft=sh
