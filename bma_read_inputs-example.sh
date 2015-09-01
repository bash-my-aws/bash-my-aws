#!/bin/bash
# # set -u

bma_read_inputs() {
  echo "${FUNCNAME}: \$@='${@}'" >&2
  if [[ -t 0 ]]; then
    echo "${FUNCNAME}: STDIN is a terminal" >&2
    echo $@
  else
    echo "${FUNCNAME}: STDIN is not a terminal" >&2
    local args="$@"
    echo "$(awk '{ print $1 }')" | 
      sed "s/.$/& /"             | 
      sed "s/$/$args/"
  fi
}

foo(){
  echo "${FUNCNAME}: \$@='${@}'" >&2
  local inputs="$(bma_read_inputs $@)"
  echo "${FUNCNAME}: inputs=${inputs}" >&2
  bar $@
}

bar(){
  echo "${FUNCNAME}: \$@='${@}'" >&2
  local inputs="$(bma_read_inputs $@)"
  echo "${FUNCNAME}: inputs=${inputs}" >&2
}
