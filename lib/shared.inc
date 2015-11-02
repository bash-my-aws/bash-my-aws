# shared.inc
#
# Source in the internal functions

source $(dirname ${BASH_SOURCE[0]})/parameter.inc

__bma_error() {
  echo "ERROR: $@" > /dev/stderr
  BMA_STATUS=1
  return 1
}

__bma_usage() {
  echo "USAGE: ${FUNCNAME[1]} $@" > /dev/stderr
}

## vim: ft=sh
