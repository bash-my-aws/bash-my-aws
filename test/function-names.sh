#!/bin/bash

# list-function-names
#
# Run from project root to generate list of all function names

for x in $(grep -h '()' lib/* | grep -v '^#' |sed 's/[\(\){]//g' | sort); do
  [[ $x == "function" ]] && continue
  echo "$x"
done



