#!/usr/bin/env bash
source $(dirname $0)/bash-spec.sh
source $(dirname $0)/../shared-functions

describe "Read Inputs" "$(

  context "Without arguments" "$(
    input=$(__bma_read_inputs)

    it "is empty" "$(
      expect "${#input}" to_be "0"
    )"
  )"

  context "With argument" "$(
    input=$(__bma_read_inputs arg1)

    it "has one argument" "$(
      expect "${input}" to_be "arg1"
    )"
  )"

  context "With arguments" "$(
    input=$(__bma_read_inputs arg1 arg2)

    it "has two arguments" "$(
      expect "${input}" to_be "arg1 arg2"
    )"
  )"

  context "With stdin" "$(
    input=$(echo "arg1" | __bma_read_inputs)

    it "has single word of input" "$(
      expect "${input}" to_be "arg1"
    )"
  )"

  context "With two words of stdin" "$(
    input=$(echo "arg1 arg2" | __bma_read_inputs)

    it "has two words of input" "$(
      expect "${input}" to_be "arg1"
    )"
  )"

  context "With two lines of stdin" "$(
    input=$(printf "arg1\narg2\n" | __bma_read_inputs)

    it "has two words of input" "$(
      expect "${input}" to_be "$(echo 'arg1 arg2')"
    )"
  )"

  context "With stdin and argument" "$(
    input=$(echo "blah" | __bma_read_inputs --switch)

    it "has two words of input" "$(
      expect "${input}" to_be "--switch blah "
    )"
  )"

  context "With two lines of stdin and argument" "$(
    input=$(printf "blah\nblah2\n" | __bma_read_inputs --switch)

    it "has two words of input" "$(
      expect "${input}" to_be "--switch blah --switch blah2 "
    )"
  )"
)"

describe "Switch STDIN" "$(
  context "without anything" "$(
    expect $(__bma_switch_with) to_be ""
    expect $(__bma_switch_with) to_be_true
  )"

  context "only switch" "$(
    expect $(__bma_switch_with --switch) to_be ""
    expect $(__bma_switch_with --switch) to_be_true
  )"

  context "only stdin" "$(
    expect $(echo "first" | __bma_switch_with) to_be "first"
    expect $(echo "first" | __bma_switch_with > /dev/null; echo $?) to_be "0"
  )"

  context "both stdin and switch" "$(
    expect "$(echo "a" | __bma_switch_with -s)" to_be "-s a "
    expect "$(echo "a b" | __bma_switch_with -s)" to_be "-s a -s b "
  )"
)"

describe "Read STDIN" "$(
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

describe "Read switch value" "$(
  context "no stdin" "$(
    expect "$(__bma_read_switch this-switch)" to_be ""
  )"

  context "single switch" "$(
    expect "$(echo "--this-switch value" | __bma_read_switch this-switch)" to_be "value"
  )"

  context "multi switch" "$(
    expect "$(echo "--this-switch value --another blah" | __bma_read_switch another)" to_be "blah"
  )"
)"
