#!/bin/bash

# extract markdown docs from code

[[ -z $1 && -t 0 ]] && echo >&2 "Usage: $0 filename(s)" && exit 1

for x in $@; do

  echo
  echo
  basename "$x" | sed -E 's/(.*)-functions/## \1-commands/g'

  cat "$x"                            |
  grep    '(){\|() {\|^  #'           |
  grep -v 'shellcheck\|TODO\|XXX'     |
  grep -v '_bma'                      |
  sed -E  's/\(\) ?\{//g'             |
  sed -E  's/^([^ ]+)/\n\n### \1\n/g' |
  sed -E  's/^  #( )?//g'

done

#  grep    '()\|^  #'                  |
