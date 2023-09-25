#!/bin/bash
#
# backup-functions

backup-jobs() {

  # List Backup Jobs
  #
  # Lists backup jobs with state and date created.
  #
  #     $ backup-jobs
  #     X9B4Z0C5-R2E8-6G39-1M2P-7H8J6MPP9H8H  COMPLETED  2023-08-27T20:00:00+10:00
  #     Y7D1F2G1-X3B2-9H77-4N8R-2F9J4JZL8F2X  COMPLETED  2023-08-27T20:00:00+10:00

  local filters=$(__bma_read_filters $@)

  aws backup list-backup-jobs \
    --output text   \
    --query '
      BackupJobs[].[
        BackupJobId,
        State,
        CreationDate
      ]'  |
    grep -E -- "$filters" |
    LC_ALL=C sort -k 3    |
    columnise
}
