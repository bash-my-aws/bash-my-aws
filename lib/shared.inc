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
  return 1
}

## vim: ft=sh
