#!/bin/bash
#
# log-functions
#
# CloudWatch Logs

log-groups() {

  # List CloudWatch Log Groups
  #
  #     $ log-groups
  #     /aws/lambda/stars2  1576495961429  0   11736
  #     /aws/lambda/stars   1576566745961  0  107460
  #     /aws/lambda/walk    1576567300172  0   11794

  local log_group_names=$(skim-stdin)
  local filters=$(__bma_read_filters $@)

  local column_command
  if column --help 2>/dev/null| grep -- --table-right > /dev/null; then
    column_command='column --table --table-right 3,4'
  else
    column_command='column -t'
  fi

  aws logs describe-log-groups    \
    --output text                 \
    --query "
      logGroups[${log_group_names:+?contains(['${log_group_names// /"','"}'], logGroupName)}].[
        logGroupName,
        creationTime,
        metricFilterCount,
        storedBytes
      ]"                |
  grep -E -- "$filters" |
  LC_ALL=C sort --key 2 |
  $column_command
}

