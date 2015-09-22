# shared.inc
#
# Source in the internal functions

source $(dirname ${BASH_SOURCE[0]})/parameter.inc

__bma_clean_query() {
  __bma_read_inputs "$@" | tr -d '[:blank:]\n'
  echo
}

## vim: ft=sh
