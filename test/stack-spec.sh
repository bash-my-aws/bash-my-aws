#!/usr/bin/env bash
source $(dirname $0)/bash-spec.sh
source $(dirname $0)/../lib/stack-functions

describe "_stack_name_arg:" "$(
  context "without an argument" "$(
    expect $(_stack_name_arg) to_be ""
  )"

  context "with a string" "$(
    expect "$(_stack_name_arg "argument")" to_be "argument"
  )"

  context "with a json file" "$(
    expect "$(_stack_name_arg "file.json")" to_be "file"
  )"

  context "with a full json path" "$(
    expect "$(_stack_name_arg "/path/to/file.json")" to_be "file"
  )"

  context "with a full xml path" "$(
    expect "$(_stack_name_arg "/path/to/file.xml")" to_be "file.xml"
  )"
)"
