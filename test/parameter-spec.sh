#!/usr/bin/env bash
source $(dirname $0)/bash-spec.sh
source $(dirname $0)/../lib/shared.inc

describe "bma_read_stdin:" "$(
  context "single word on a single line" "$(
    expect "$(echo "a" | __bma_read_stdin)" to_be "a"
  )"

  context "multi word on a single line" "$(
    expect "$(echo "a blah" | __bma_read_stdin)" to_be "a"
  )"

  context "single word on multi line" "$(
    expect "$(printf "a\nb" | __bma_read_stdin)" to_be "a b"
  )"

  context "multi word on a single line" "$(
    expect "$(printf "a blah\nb else\n" | __bma_read_stdin)" to_be "a b"
  )"
)"

describe "bma_read_inputs:" "$(
  context "empty" "$(
    val=$(__bma_read_stdin)
    expect "${val:-empty}" to_be "empty"
  )"

  context "with stdin" "$(
    val=$(echo "a blah" | __bma_read_inputs)
    expect "${val:-empty}" to_be "a"
  )"

  context "with argv" "$(
    val=$(__bma_read_inputs "argv")
    expect "${val:-empty}" to_be "argv"
  )"

  context "multi word on a single line" "$(
    val=$(printf "a blah\nb else\n" | __bma_read_inputs)
    expect "${val:-empty}" to_be "a b"
  )"
)"


describe "bma_read_resources:" "$(
  context "one value" "$(
    str=$(echo "r1")
    val=$(__bma_read_resources ${str})
    expect "$(echo ${val:-empty})" to_be "r1"
  )"

  context "two values" "$(
    str=$(echo "r1 r2 --a-switch a-value r3")
    val=$(__bma_read_resources ${str})
    expect "$(echo ${val:-empty})" to_be "r1 r2"
  )"

  context "one switch two values" "$(
    str=$(echo "i-8a7de654 i-b4c0176b --debug")
    val=$(__bma_read_resources ${str})
    expect "$(echo ${val:-empty})" to_be "i-8a7de654 i-b4c0176b"
  )"

  context "returns one resource per line" "$(
    str="$(echo -e "one two three four")"
    expect $(__bma_read_resources ${str} | wc -l) to_be "4"
  )"
)"

describe "bma_read_switches:" "$(
  context "one switch with value" "$(
    str=$(echo "r1 r2 --a-switch a-value r3")
    val=$(__bma_read_switches ${str})
    expect "$(echo ${val:-empty})" to_be "--a-switch a-value r3"
  )"

  context "two switches with values" "$(
    str=$(echo "r1 r2 --a-switch a-value r3 --another one_more")
    val=$(__bma_read_switches ${str})
    expect "$(echo ${val:-empty})" to_be "--a-switch a-value r3 --another one_more"
  )"

  context "switches with long value" "$(
    str=$(echo "--switch 'with a long value'")
    val=$(__bma_read_switches ${str})
    expect "$(echo ${val:-empty})" to_be "--switch 'with a long value'"
  )"

  context "duplicate switches" "$(
    str=$(echo "--switch 'with a long value' --switch 'another'")
    val=$(__bma_read_switches ${str})
    expect "$(echo ${val:-empty})" to_be "--switch 'another' --switch 'with a long value'"
  )"

  context "expanded switches" "$(
    str=$(echo "--json")
    val=$(__bma_read_switches ${str})
    expect "$(echo ${val:-empty})" to_be "--output json"
  )"

  context "returns one switch per line" "$(
    str="$(echo "--one 1 --two 2 | wc -l")"
    expect $(__bma_read_switches ${str} | wc -l) to_be "2"
  )"
)"

describe "bma_arg_types:" "$(
  context "empty" "$(
    val=$(__bma_arg_types)
    expect "${val:-empty}" to_be "empty"
  )"

  context "one resource" "$(
    val=$(__bma_arg_types $(echo i-abc))
    expect "${val:-empty}" to_be "r:i-abc"
  )"

  context "one switch" "$(
    val=$(__bma_arg_types $(echo --switch))
    expect "${val:-empty}" to_be "s:--switch"
  )"

  context "one switch with value" "$(
    val=$(__bma_arg_types $(echo --a-switch a-value))
    expect "$(echo ${val:-empty})" to_be "s:--a-switch a-value"
  )"

  context "switches with long value" "$(
    val=$(__bma_arg_types $(echo --switch with a long value))
    expect "$(echo ${val:-empty})" to_be "s:--switch with a long value"
  )"
)"

describe "bma_expand_switches:" "$(
  context "with --debug" "$(
    str=$(echo "--debug")
    val=$(__bma_expand_switches ${str})
    expect "${val:-empty}" to_be "--debug"
  )"

  context "with --json" "$(
    str=$(echo "--json")
    val=$(__bma_expand_switches ${str})
    expect "${val:-empty}" to_be "--output json"
  )"

  context "with --text" "$(
    str=$(echo "--text")
    val=$(__bma_expand_switches ${str})
    expect "${val:-empty}" to_be "--output text"
  )"

  context "with -f" "$(
    str=$(echo "-f 'this is the filter'")
    val=$(__bma_expand_switches ${str})
    expect "${val:-empty}" to_be "--filters 'this is the filter'"
  )"

  context "with -q" "$(
    str=$(echo "-q 'this is the query'")
    val=$(__bma_expand_switches ${str})
    expect "${val:-empty}" to_be "--query 'this is the query'"
  )"

  context "returns one switch per line" "$(
    str="$(echo -e "--one 1\n--two 2")"
    expect $(__bma_expand_switches "${str}" | wc -l) to_be "2"
  )"
)"
