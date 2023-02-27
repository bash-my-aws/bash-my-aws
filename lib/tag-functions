#!/bin/bash
#
# tag-functions

tag-keys() {

  # List unique set of tag keys in AWS Account / Region
  #
  #     USAGE: tag-keys

  aws resourcegroupstaggingapi get-tag-keys \
    --output text                           \
    --query 'TagKeys[].[@]'                 |
  sort
}

tag-values() {

  # List unique set of tag values for key in AWS Account / Region
  #
  #     USAGE: tag-values key

  local key="${1:-}"
  [[ -z $key ]] && __bma_usage "key" && return 1
  aws resourcegroupstaggingapi get-tag-values \
    --key "$key"                              \
    --output text                             \
    --query "TagValues[].['$key', @]"         |
  sort
}
