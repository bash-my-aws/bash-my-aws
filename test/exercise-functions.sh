#!/bin/bash


source ~/.bash-my-aws/bin/bma

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
