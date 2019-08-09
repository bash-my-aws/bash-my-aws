bma_path="$(cd "$(dirname "$0")" && pwd)"

_bma_elbs_completion() {
    local command="$1"
    local word="$2"
    local options=$(elbs)
    COMPREPLY=($(compgen -W "${options}" -- ${word}))
    return 0
}

_bma_stacks_completion() {
  local command="$1"
  local word="$2"
  if [ "${COMP_CWORD}" -eq 1 ] || [ "${COMP_CWORD}" -eq 2 ] && [ "${command}" = 'bma' ]; then
    COMPREPLY=( $(compgen -W "$(stacks | awk '{ print $1 }')" -- "${word}") )
  else
    COMPREPLY=( $(compgen -f "${word}") )
  fi
  return 0
}

_bma_keypairs_completion() {
  local command="$1"
  local word="$2"

  if [ "${COMP_CWORD}" -eq 1 ] || [ "${COMP_CWORD}" -eq 2 ] && [ "${command}" = 'bma' ]; then
    COMPREPLY=( $(compgen -W "$(keypairs | awk '{ print $1 }')" -- ${word}) )
  else
    COMPREPLY=( $(compgen -f "${word}") )
  fi
  return 0
}

_bma_instances_completion() {
    local command="$1"
    local word="$2"

    case $word in
      "") options="i-a i-b" ;;
      *)  options=$(instances) ;;
    esac

    COMPREPLY=($(compgen -W "${options}" -- ${word}))
    return 0
}

_bma_asgs_completion() {
    local command="$1"
    local word="$2"
    local options=$(asgs --query 'AutoScalingGroups[][{"AutoScalingGroupName": AutoScalingGroupName}][]')
    COMPREPLY=($(compgen -W "${options}" -- ${word}))
    return 0
}

_bma_completion() {
  local word
  word="$2"
  if [ "${COMP_CWORD}" -eq 1 ]; then
    _bma_functions_completion "$word"
  else
    _bma_subcommands_completion "${COMP_WORDS[1]}" "$word"
  fi
}

_bma_functions_completion() {
  local word all_funcs
  word="$1"
  all_funcs=$(cat "${bma_path}/functions")
  COMPREPLY=($(compgen -W "${all_funcs}" -- ${word}))
  return
}

_bma_subcommands_completion() {
  local subcommand word subcommand_completion
  subcommand="$1"
  word="$2"

  subcommand_completion=$(                \
    complete -p                           \
    | command grep "_bma_"                \
    | command grep -w "${subcommand:-}"   \
    | command awk '{print $3}'
  )

  if [ -n "${subcommand_completion}" ]; then
    if [ -n "${AWS_DEFAULT_REGION}" ]; then
      $subcommand_completion "bma" "${word:-0}"
    else
      COMPREPLY=""
      return 0
    fi
  fi
  return 0
}

complete -F _bma_instances_completion instances
complete -F _bma_instances_completion instance-asg
complete -F _bma_instances_completion instance-az
complete -F _bma_instances_completion instance-console
complete -F _bma_instances_completion instance-dns
complete -F _bma_instances_completion instance-iam-profile
complete -F _bma_instances_completion instance-ip
complete -F _bma_instances_completion instance-ssh
complete -F _bma_instances_completion instance-ssh-details
complete -F _bma_instances_completion instance-stack
complete -F _bma_instances_completion instance-start
complete -F _bma_instances_completion instance-state
complete -F _bma_instances_completion instance-stop
complete -F _bma_instances_completion instance-tags
complete -F _bma_instances_completion instance-terminate
complete -F _bma_instances_completion instance-type
complete -F _bma_instances_completion instance-userdata
complete -F _bma_instances_completion instance-volumes
complete -F _bma_instances_completion instance-vpc
complete -F _bma_keypairs_completion keypair-delete
complete -F _bma_asgs_completion asgs
complete -F _bma_asgs_completion asg-capacity
complete -F _bma_asgs_completion asg-instances
complete -F _bma_asgs_completion asg-processes_suspended
complete -F _bma_asgs_completion asg-resume
complete -F _bma_asgs_completion asg-stack
complete -F _bma_asgs_completion asg-suspend
complete -F _bma_asgs_completion asg-scaling-activities
complete -F _bma_stacks_completion stacks
complete -F _bma_stacks_completion stack-cancel-update
complete -F _bma_stacks_completion stack-update
complete -F _bma_stacks_completion stack-delete
complete -F _bma_stacks_completion stack-exports
complete -F _bma_stacks_completion stack-recreate
complete -F _bma_stacks_completion stack-failure
complete -F _bma_stacks_completion stack-events
complete -F _bma_stacks_completion stack-resources
complete -F _bma_stacks_completion stack-asg-instances
complete -F _bma_stacks_completion stack-asgs
complete -F _bma_stacks_completion stack-elbs
complete -F _bma_stacks_completion stack-instances
complete -F _bma_stacks_completion stack-parameters
complete -F _bma_stacks_completion stack-tags
complete -F _bma_stacks_completion stack-status
complete -F _bma_stacks_completion stack-tail
complete -F _bma_stacks_completion stack-template
complete -F _bma_stacks_completion stack-outputs
complete -F _bma_stacks_completion stack-diff
complete -F _bma_elbs_completion elb-instances
complete -f stack-validate
complete -F _bma_completion bma

