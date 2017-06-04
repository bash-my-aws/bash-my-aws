#!/usr/bin/env bash
source $(dirname $0)/bash-spec.sh
source $(dirname $0)/../lib/shared-functions

describe "bma_usage:" "$(
  context "with a string" "$(
    expect "$(__bma_usage "something" 2>&1)" to_be "USAGE: main something"
  )"
)"

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
