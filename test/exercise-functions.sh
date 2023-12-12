#!/usr/bin/env bash

      for f in ${BMA_HOME:-$HOME/.bash-my-aws}/lib/*-functions; do source $f; done
source "${BMA_HOME:-$HOME/.bash-my-aws}"/bin/bma

# init function override for aws
aws() {
  echo "aws $@"
}

# override to make output prettier
base64() {
  cat
}

# Don't run this one
stack-tail() {
  :
}

cmd() {
  echo "# Command: $@"
  $@
  echo
}

source commands
