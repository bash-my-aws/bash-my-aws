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
      expect "${input}" to_be $(echo -n 'arg1')
    )"
  )"

  context "With stdins" "$(
    input=$(__bma_read_inputs arg1 arg2)

    it "has two words of input" "$(
      expect "${input}" to_be "arg1 arg2"
    )"
  )"

  context "With stdin and argument" "$(
    input=$(__bma_read_inputs arg1 arg2)

    it "has two words of input" "$(
      expect "${input}" to_be "arg1 arg2"
    )"
  )"
)"
