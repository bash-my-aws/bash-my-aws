#!/bin/bash
#
# secretsmanager-functions

secrets() {
  aws secretsmanager list-secrets  \
    --output text \
    --query 'SecretList[].[Name, Description, CreatedDate]' |
  columnise
}
