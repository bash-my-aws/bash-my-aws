#!/usr/bin/env bash
source $(dirname $0)/bash-spec.sh
source $(dirname $0)/../lib/stack-functions
source $(dirname $0)/../lib/shared-functions

describe "_bma_stack_name_arg:" "$(
  context "without an argument" "$(
    expect $(_bma_stack_name_arg) to_be ""
  )"

  context "with a string" "$(
    expect "$(_bma_stack_name_arg "argument")" to_be "argument"
  )"

  context "with a file extension" "$(
    expect "$(_bma_stack_name_arg "file.json")" to_be "file"
  )"

  context "with a full json path" "$(
    expect "$(_bma_stack_name_arg "/path/to/file.json")" to_be "file"
  )"

  context "with a yaml file" "$(
    expect "$(_bma_stack_name_arg "file.yaml")" to_be "file"
  )"

  context "with a yml file" "$(
    expect "$(_bma_stack_name_arg "file.yml")" to_be "file"
  )"

  context "with a full yaml path" "$(
    expect "$(_bma_stack_name_arg "/path/to/file.yaml")" to_be "file"
  )"

  context "with a full xml path" "$(
    expect "$(_bma_stack_name_arg "/path/to/file.xml")" to_be "file"
  )"
)"

describe "_bma_stack_template_arg:" "$(
  context "cannot find template without any details" "$(
    expect $(_bma_stack_template_arg) to_be ""
  )"

  context "cannot find template with only stack name" "$(
    expect $(_bma_stack_template_arg "stack") to_be ""
  )"

  context "cannot find template when it's gone" "$(
    expect $(_bma_stack_template_arg "stack" /file/is/gone) to_be "/file/is/gone"
  )"

  context "can find template when it exists" "$(
    cd ${TMPDIR}
    touch stack.json
    expect $(_bma_stack_template_arg "stack") to_be "stack.json"
    rm stack.json
  )"

  context "can find template when stack is hyphenated and it exists" "$(
    cd ${TMPDIR}
    touch stack.json
    expect $(_bma_stack_template_arg "stack-example") to_be "stack.json"
    rm stack.json
  )"

  context "can find template when it is provided" "$(
    tmpfile=$(mktemp -t bma.XXX)
    expect $(_bma_stack_template_arg "stack" "${tmpfile}") to_be "${tmpfile}"
    rm ${tmpfile}
  )"

)"

[[ -d cloudformation/params ]] || mkdir -p cloudformation/params


# templates
touch            \
  $(dirname $0)/cloudformation/great-app.json \
  $(dirname $0)/cloudformation/great-app.yml  \
  $(dirname $0)/cloudformation/great-app.yaml \

# params

[[ -d params ]] || mkdir params

touch                                      \
  $(dirname $0)/cloudformation/great-app-params.json                    \
  $(dirname $0)/cloudformation/great-app-params-staging.json            \
  $(dirname $0)/cloudformation/great-app-params-another-env.json        \
  $(dirname $0)/cloudformation/params/great-app-params.json             \
  $(dirname $0)/cloudformation/params/great-app-params-staging.json     \
  $(dirname $0)/cloudformation/params/great-app-params-another-env.json

cd $(dirname $0)/cloudformation

describe "_bma_stack_args:" "$(
  context "without an argument" "$(
    expect $(_bma_stack_args) to_be ""
  )"

  context "with a stack" "$(
    expect "$(_bma_stack_args great-app)" to_be "Resolved arguments: great-app ./great-app.json "
  )"

  context "with a template" "$(
    expect "$(_bma_stack_args great-app.yaml)" to_be "Resolved arguments: great-app great-app.yaml ./great-app-params.json"
  )"

  context "with a params file" "$(
    expect "$(_bma_stack_args params/great-app-params-staging.json)" to_be "Resolved arguments: great-app-staging ./great-app.json params/great-app-params-staging.json"
  )"

)"

cd -
