# shared.inc
#
# Source in the internal functions
if [[ $(basename ${SHELL}) == "zsh" ]]; then
  source $(dirname ${(%):-%N})/parameter.inc
else
  source $(dirname ${BASH_SOURCE[0]})/parameter.inc
fi

__bma_error() {
  echo "ERROR: $@" > /dev/stderr
  BMA_STATUS=1
  # TODO: Return zero. Returning non-zero should only happen when there is a
  # failure to return an error.
  return 1
}

__bma_usage() {
  echo "USAGE: ${FUNCNAME[1]} $@" > /dev/stderr
}

## vim: ft=sh
