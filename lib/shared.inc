# shared.inc
#
# Source in the internal functions

source $(dirname ${BASH_SOURCE[0]})/parameter.inc

__bma_clean_query() {
  echo $@ | tr -d '[:blank:]\n'
  echo
}

## vim: ft=sh
