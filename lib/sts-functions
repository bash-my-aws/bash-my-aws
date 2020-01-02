#!/bin/bash
#
# sts-functions
#
# AWS Simple Token Service functions

sts-assume-role() {

  # Assume an IAM Role
  #
  #     USAGE: sts-assume-role role_arn

  local role_arn=$1
  local time_stamp=$(date +%s)
  [[ -z "${role_arn}" ]] && __bma_usage "role_arn" && return 1
  aws sts assume-role                 \
    --role-arn "$role_arn"            \
    --role-session-name "$time_stamp" \
    --duration-seconds 900            \
    --output text                     \
    --query 'Credentials.[
      [join(`=`, [`AWS_ACCESS_KEY_ID`, AccessKeyId])],
      [join(`=`, [`AWS_SECRET_ACCESS_KEY`, SecretAccessKey])],
      [join(`=`, [`AWS_SESSION_TOKEN`, SessionToken])],
      [join(`=`, [`AWS_SECURITY_TOKEN`, SessionToken])]
    ]'
}
