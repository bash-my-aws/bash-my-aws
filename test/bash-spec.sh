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

result_file=$RANDOM

exec 6<&1
exec > "$result_file"

function output_results {
  exec 1>&6 6>&-
  local results=$( cat "$result_file" )
  rm "$result_file"
  local passes=$( echo "$results" | grep "PASS" | wc -l )
  local fails=$( echo "$results" | grep "\*\*\*\* FAIL" | wc -l )
  echo "$results"
  echo "--SUMMARY--"
  echo "$passes PASSED"
  echo "$fails FAILED"
  if [[ $fails -gt 0 ]]; then
    exit 1
  else
    exit 0
  fi
}

function _array_contains_ {
  for elem in "${_actual_[@]}"; do
      if [[ "$elem" == "$_expected_" ]]; then
          return 0
      fi
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
  echo "  $1"
  echo "    $2"
}

function describe {
  echo "$1"
  echo "$2"
}

function context {
  echo "$1"
  echo "$2"
}

function pass {
  echo "     PASS"
}

function fail {
  echo "**** FAIL - expected:$( if [[ "$_negation_" == true ]]; then echo " NOT"; fi; ) $_expected_ | actual: ${_actual_[@]}"
}

function expect {
  _expected_=
    _negation_=false
    declare -a _actual_
    until [[ "$1" == to_* || "$1" == not || -z "$1" ]]; do
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
    if [[ "${_actual_[0]}" == "$_expected_" ]]; then 
        _pass_=true
    else
        _pass_=false
    fi
    _negation_check_
}

function to_be_true {
  _expected_="$@ IS TRUE"
  if $@; then
    _pass_=true
    _actual_="$@ IS TRUE"
  else
    _pass=false
    _actual_="$@ IS FALSE"
  fi
  _negation_check_
}

function to_match {
    _expected_="$1"
    if [[ "${_actual_[0]}" =~ $_expected_ ]]; then 
        _pass_=true
    else
        _pass_=false
    fi
    _negation_check_
}

function to_contain {
    _expected_="$1"
    
    if _array_contains_ "$_expected_" "$_actual_"; then 
        _pass_=true
    else
        _pass_=false
    fi
    _negation_check_
}

function to_exist {
  if [[ -e "${_actual_[0]}" ]]; then
        _pass_=true
        if [[ "$_negation_" == true ]]; then
          _expected_="$_actual_ EXISTS"
        fi
    else
        _pass_=false
        _expected_="$_actual_ EXISTS"
        _actual_="File not found"
    fi
    _negation_check_
}

function to_have_mode { 
    _filename_="${_actual_[0]}"
    _expected_="$1"
    if [[ -e "$_filename_" ]]; then
      _fullname_="$_filename_"
    else
      _fullname_="$(which $_filename_)"
    fi  
    if [[ -e "$_fullname_" ]]; then
      _os_=$(uname -a | cut -f 1 -d ' ')
      if [[ $_os_ == Linux ]]; then
        _actual_="$(stat -c %A $_fullname_)"
      else
        _actual_="$(stat $_fullname_ | cut -f 3 -d ' ')"
      fi
      if [[ "$_actual_" =~ $_expected_ ]]; then
        _pass_=true
      else
        _pass_=false
      fi
      _negation_check_
    else
      echo "File not found: $_fullname_"
    fi        
}

TEMP=`getopt -o h --long help \
             -n 'javawrap' -- "$@"`

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
