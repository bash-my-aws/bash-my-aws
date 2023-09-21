#!/usr/bin/env bash

      for f in ${BMA_HOME:-$HOME/.bash-my-aws}/lib/*-functions; do source $f; done
source "${BMA_HOME:-$HOME/.bash-my-aws}"/bin/bma

# init function override for aws
function aws() {
  echo "aws $@"
}

# override to make output prettier
function base64() {
  cat
}

# Don't run this one
function stack-tail() {
  :
}

function cmd() {
  echo "# Command: $@"
  $@
  echo
}

source commands
