#!/bin/bash
#==================================================================================
# BDD-style testing framework for bash scripts.
#
# expect variable [not] to_be value               Compare scalar values for equality
# expect variable [not] to_match regex            Regex match
# expect array [not] to_contain value             Look for a value in an array
# expect filename [not] to_exist                  Verify file existence
# expect filename [not] to_have_mode modestring   Verify file mode (permissions)
# expect [not] to_be_true condition               Verify exit mode as boolean
#
# Author: Dave Nicolette
# Date: 29 Jul 2014
# Modified by REA Group 2014
#==================================================================================

# XXX: should use mktemp for proper random file name -- (GM)
result_file="$RANDOM"
_passed_=0
_failed_=0

exec 6<&1
exec > "$result_file"

function output_results {
  exec 1>&6 6>&-
  local results="$(<$result_file)"
  rm -f -- "$result_file"
  local passes=$(printf '%s' "$results" | grep -F PASS | wc -l)
  local fails=$(printf '%s' "$results" | grep -F '**** FAIL' | wc -l )
  printf '%s\n--SUMMARY\n%d PASSED\n%d FAILED\n' "$results" "$passes" "$fails"
  [[ ${fails:-1} -eq 0 ]]
  exit $?
}

function _array_contains_ {
  for elem in "${_actual_[@]}"; do
    [[ "$elem" == "$_expected_" ]] && return 0
  done
  return 1
}

function _negation_check_ {
  if [[ "$_negation_" == true ]]; then
    if [[ "$_pass_" == true ]]; then
      _pass_=false
    else
      _pass_=true
    fi
  fi
  if [[ "$_pass_" == true ]]; then
    (( _passed_+=1 ))
    pass
  else
    (( _failed_+=1 ))
    fail
  fi
}

function it {
  printf '  %s\n    %s\n' "$1" "$2"
}

function describe {
  printf '%s\n%s\n' "$1" "$2"
}

function context {
  printf '%s\n%s\n' "$1" "$2"
}

function pass {
  echo "     PASS"
}

function fail {
  echo "**** FAIL - expected:$( if [[ "$_negation_" == true ]]; then echo ' NOT'; fi; ) '$_expected_' | actual: '${_actual_[@]}'"
}

function expect {
  _expected_=
  _negation_=false
  declare -a _actual_
  until [[ "${1:0:3}" == to_ || "$1" == not || -z "$1" ]]; do
    _actual_+=("$1")
    shift
  done
  "$@"
}

function not {
  _negation_=true
  "$@"
}

function to_be {
  _expected_="$1"
  _pass_=false
  [[ "${_actual_[0]}" == "$_expected_" ]] && _pass_=true
  _negation_check_
}

function to_be_true {
  _expected_="$@ IS TRUE"
  _pass=false
  _actual_="$@ IS FALSE"
  if "$@"; then
    _pass_=true
    _actual_="$@ IS TRUE"
  fi
  _negation_check_
}

function to_match {
  _expected_="$1"
  _pass_=false
  [[ "${_actual_[0]}" =~ $_expected_ ]] && _pass_=true
  _negation_check_
}

function to_contain {
  _expected_="$1"
  _pass_=false
  _array_contains_ "$_expected_" "$_actual_" && _pass_=true
  _negation_check_
}

function to_exist {
  _pass_=false
  _expected_="$_actual_ EXISTS"
  if [[ -e "${_actual_[0]}" ]]; then
    _pass_=true
    [[ "$_negation_" == true ]] && _expected_="$_actual_ EXISTS"
  else
    _actual_="File not found"
  fi
  _negation_check_
}

function to_have_mode {
  _filename_="${_actual_[0]}"
  _expected_="$1"
  _pass_=false
  if [[ -e "$_filename_" ]]; then
    _fullname_="$_filename_"
  else
    _fullname_="$(which $_filename_)"
  fi
  if [[ -e "$_fullname_" ]]; then
    _os_="$(uname -s)"
    if [[ "$_os_" == Linux ]]; then
      _actual_="$(stat -c %A $_fullname_)"
    else
      _actual_="$(stat $_fullname_ | cut -f 3 -d ' ')"
    fi
    [[ "$_actual_" =~ "$_expected_" ]] && _pass_=true
  else
    echo "File not found: $_fullname_"
  fi
  _negation_check_
}

TEMP="$(getopt -o h --long help \
             -n 'javawrap' -- $@)"

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
  case "$1" in
    -h | --help ) show_help; exit 0 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

trap output_results EXIT
