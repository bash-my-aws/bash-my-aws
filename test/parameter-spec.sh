#!/usr/bin/env bash
source $(dirname $0)/bash-spec.sh
source $(dirname $0)/../parameter-functions

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
  context "one switch with value" "$(
    val=$(__bma_read_resources r1 r2 --a-switch a-value r3)
    expect "$(echo ${val:-empty})" to_be "r1 r2"
  )"
)"

describe "bma_read_switches:" "$(
  context "one switch with value" "$(
    val=$(__bma_read_switches r1 r2 --a-switch a-value r3)
    expect "$(echo ${val:-empty})" to_be "--a-switch a-value r3"
  )"

  context "two switches with values" "$(
    val=$(__bma_read_switches r1 r2 --a-switch a-value r3 --another one_more)
    expect "$(echo ${val:-empty})" to_be "--a-switch a-value r3 --another one_more"
  )"

  context "switches with long value" "$(
    val=$(__bma_read_switches --switch 'with a long value')
    expect "$(echo ${val:-empty})" to_be "--switch with a long value"
  )"
)"

describe "bma_arg_types:" "$(
  context "empty" "$(
    val=$(__bma_arg_types)
    expect "${val:-empty}" to_be "empty"
  )"

  context "one resource" "$(
    val=$(__bma_arg_types i-abc)
    expect "${val:-empty}" to_be "r:i-abc"
  )"

  context "one switch" "$(
    val=$(__bma_arg_types --switch)
    expect "${val:-empty}" to_be "s:--switch"
  )"

  context "one switch with value" "$(
    val=$(__bma_arg_types --a-switch a-value)
    expect "$(echo ${val:-empty})" to_be "s:--a-switch a-value"
  )"

  context "switches with long value" "$(
    val=$(__bma_arg_types --switch with a long value)
    expect "$(echo ${val:-empty})" to_be "s:--switch with a long value"
  )"
)"
