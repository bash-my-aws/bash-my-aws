#!/usr/bin/env bash
source $(dirname $0)/bash-spec.sh
source $(dirname $0)/../lib/shared.inc

describe "bma_usage:" "$(
  context "with a string" "$(
    expect "$(__bma_usage "something" 2>&1)" to_be "USAGE: main something"
  )"
)"

describe "bma_error:" "$(
  context "with a string" "$(
    expect "$(__bma_error "error" 2>&1)" to_be "ERROR: error"
  )"
)"
