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
    expect "$(echo ${val:-empty})" to_be "r1 r2 r3"
  )"
)"

describe "bma_read_switches:" "$(
  context "one switch with value" "$(
    val=$(__bma_read_switches r1 r2 --a-switch a-value r3)
    expect "$(echo ${val:-empty})" to_be "--a-switch 'a-value'"
  )"

  context "two switches with values" "$(
    val=$(__bma_read_switches r1 r2 --a-switch a-value r3 --another one_more)
    expect "$(echo ${val:-empty})" to_be "--a-switch 'a-value' --another 'one_more'"
  )"

  context "switches with long value" "$(
    val=$(__bma_read_switches --switch 'with a long value')
    expect "$(echo ${val:-empty})" to_be "--switch 'with a long value'"
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
    val=$(__bma_arg_types --a-switch a-value )
    expect "$(echo ${val:-empty})" to_be "s:--a-switch v:'a-value'"
  )"

  context "switches with long value" "$(
    val=$(__bma_arg_types --switch 'with a long value')
    expect "$(echo ${val:-empty})" to_be "s:--switch v:'with a long value'"
  )"
)"

#
#  context "Without arguments" "$(
#    input=$(__bma_read_inputs)
#
#    it "is empty" "$(
#      expect "${#input}" to_be "0"
#    )"
#  )"
#
#  context "With argument" "$(
#    input=$(__bma_read_inputs arg1)
#
#    it "has one argument" "$(
#      expect "${input}" to_be "arg1"
#    )"
#  )"
#
#  context "With arguments" "$(
#    input=$(__bma_read_inputs arg1 arg2)
#
#    it "has two arguments" "$(
#      expect "${input}" to_be "arg1 arg2"
#    )"
#  )"
#
#  context "With stdin" "$(
#    input=$(echo "arg1" | __bma_read_inputs)
#
#    it "has single word of input" "$(
#      expect "${input}" to_be "arg1"
#    )"
#  )"
#
#  context "With two words of stdin" "$(
#    input=$(echo "arg1 arg2" | __bma_read_inputs)
#
#    it "has two words of input" "$(
#      expect "${input}" to_be "arg1"
#    )"
#  )"
#
#  context "With two lines of stdin" "$(
#    input=$(printf "arg1\narg2\n" | __bma_read_inputs)
#
#    it "has two words of input" "$(
#      expect "${input}" to_be "$(echo 'arg1 arg2')"
#    )"
#  )"
#
#  context "With stdin and argument" "$(
#    input=$(echo "blah" | __bma_read_inputs --switch)
#
#    it "has two words of input" "$(
#      expect "${input}" to_be "--switch blah "
#    )"
#  )"
#
#  context "With two lines of stdin and argument" "$(
#    input=$(printf "blah\nblah2\n" | __bma_read_inputs --switch)
#
#    it "has two words of input" "$(
#      expect "${input}" to_be "--switch blah --switch blah2 "
#    )"
#  )"
#)"
#
#describe "Switch STDIN" "$(
#  context "without anything" "$(
#    expect $(__bma_switch_with) to_be ""
#    expect $(__bma_switch_with) to_be_true
#  )"
#
#  context "only switch" "$(
#    expect $(__bma_switch_with --switch) to_be ""
#    expect $(__bma_switch_with --switch) to_be_true
#  )"
#
#  context "only stdin" "$(
#    expect $(echo "first" | __bma_switch_with) to_be "first"
#    expect $(echo "first" | __bma_switch_with > /dev/null; echo $?) to_be "0"
#  )"
#
#  context "both stdin and switch" "$(
#    expect "$(echo "a" | __bma_switch_with -s)" to_be "-s a "
#    expect "$(echo "a b" | __bma_switch_with -s)" to_be "-s a -s b "
#  )"
#)"
#
#describe "Read switch value" "$(
#  context "no stdin" "$(
#    expect "$(__bma_read_switch this-switch)" to_be ""
#  )"
#
#  context "single switch" "$(
#    expect "$(echo "--this-switch value" | __bma_read_switch this-switch)" to_be "value"
#  )"
#
#  context "multi switch" "$(
#    expect "$(echo "--this-switch value --another blah" | __bma_read_switch another)" to_be "blah"
#  )"
#)"
#
#describe "Extract resources" "$(
#  context "with only stdin" "$(
#    expect "$(echo "r1" | __bma_extract_resources)" to_be "r2"
#  )"
#)"
