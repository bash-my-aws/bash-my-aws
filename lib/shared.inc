# shared.inc
#
# Source in the internal functions

source $(dirname ${BASH_SOURCE[0]})/parameter.inc

__bma_clean_query() {
  echo $@ | tr -d '[:blank:]\n'
  echo
}

__bma_error() {
  echo "ERROR: $@" > /dev/stderr
  BMA_STATUS=1
  return 1
}

__bma_aws_error() {
  if [[ ! -z "$@" ]]; then
    __bma_error $(echo "$@" | grep -v ^$ | cut -d: -f2 | sed 's/^\ *//g')
  fi
}

__bma_exec_aws() {
  cmd="$@"
  output=$( ${cmd} 2>&1 )

  if [[ $? -ne 0 ]]; then
    __bma_aws_error "${output}"
    return 1
  fi

  echo -n "${output}"
  return 0
}

## vim: ft=sh
