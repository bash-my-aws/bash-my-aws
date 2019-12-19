#!/bin/bash

# [localstack services/ports](https://github.com/localstack/localstack#overview)

DEBUG=1 SERVICES="cloudformation,ec2,iam,KMS,kms,lambda,route53,sts,s3" localstack start --host &

# Set aws-account-alias
awslocal iam create-account-alias --account-alias demo-account
