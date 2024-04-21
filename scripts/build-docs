#!/bin/bash

COMMAND_REFERENCE_FILE=docs/command-reference.md

filelist="lib/aws-account-functions
lib/region-functions
lib/stack-functions
lib/instance-functions
"

filelist="${filelist}$(ls lib/* | grep -v 'aws-account\|region\|stack\|instance\|shared\|misc\|git\|github\|pkcs12\|extras')"

cp docs/.command-reference-intro.md $COMMAND_REFERENCE_FILE

scripts/extract-docs $filelist | tee -a $COMMAND_REFERENCE_FILE
