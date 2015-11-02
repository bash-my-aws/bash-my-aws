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

describe "_stack_template_arg:" "$(
  context "cannot find template without any details" "$(
    expect $(_stack_template_arg) to_be ""
  )"

  context "cannot find template with only stack name" "$(
    expect $(_stack_template_arg "stack") to_be ""
  )"

  context "cannot find template when it's gone" "$(
    expect $(_stack_template_arg "stack" /file/is/gone) to_be "/file/is/gone"
  )"

  context "can find template when it exists" "$(
    cd ${TMPDIR}
    touch stack.json
    expect $(_stack_template_arg "stack") to_be "stack.json"
    rm stack.json
  )"

  context "can find template when it is provided" "$(
    tmpfile=$(mktemp -t bma.XXX)
    expect $(_stack_template_arg "stack" "${tmpfile}") to_be "${tmpfile}"
    rm ${tmpfile}
  )"

)"
