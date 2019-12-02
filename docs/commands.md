




## stack-commands

Act on CloudFormation stacks.

This was where `bash-my-aws` started back in 2014. A few of these functions do not yet
accept multiple stacks as piped input.

### stacks
### stack-arn
### stack-asg-instances
### stack-asgs
### stack-cancel-update
### stack-create
### stack-delete
### stack-diff
### stack-elbs
### stack-events
### stack-exports
### stack-failure
### stack-instances
### stack-outputs
### stack-parameters
### stack-recreate
### stack-resources
### stack-status
### stack-tag
### stack-tag-apply
### stack-tag-delete
### stack-tags
### stack-tags-text
### stack-tail
### stack-template
### stack-update
### stack-validate


## asg-functions
### asg-capacity
### asg-desired-size-set
### asg-instances
### asg-launch-configuration
### asg-max-size-set
### asg-min-size-set
### asg-processes_suspended
### asg-resume
### asg-scaling-activities
### asg-stack
### asg-suspend
### asgs


## aws-account-functions

These functions target AWS Accounts and act on either the account you're
authenticated to or the Account IDs provided to them.

### aws-account-alias

Retrieve AWS Account Alias for current account

```shell
$ aws-account-alias
example-account-prod
```


### aws-account-cost-explorer
### aws-account-cost-recommendations

### aws-account-each

Run a script/command across a number of AWS Accounts

```shell
$ grep non_prod AWS_ACCOUNTS | aws-account-each stacks FAILED

# account=012345678901 alias=example-account-prod
example-stack1-prod  CREATED_FAILED
example-stack2-prod  UPDATE_ROLLBACK_FAILED
# account=123456789012 alias=example-account-staging
example-stack1-staging  CREATED_FAILED
example-stack2-staging  UPDATE_ROLLBACK_FAILED
```

### aws-account-id

Retrieve AWS Account ID for current account

```shell
$ aws-account-id
012345678901
```

## bucket-functions

### buckets
### bucket-acls
### bucket-remove
### bucket-remove-force

## cert-functions

ACM Certificates

### certs
### cert-delete
### cert-users
### certs-arn


### cloudtrail-status
### cloudtrails
### columnise

## ecr-functions

### ecr-repositories
### ecr-repository-images


## elb-functions

### elb-dnsname
### elb-instances
### elb-stack
### elbs


## iam-functions

### iam-role-principal
### iam-roles
### image-deregister
### images


## instance-functions

### instance-asg
### instance-az
### instance-console
### instance-dns
### instance-iam-profile
### instance-ip
### instance-ssh
### instance-ssh-details
### instance-stack
### instance-start
### instance-state
### instance-stop
### instance-tags
### instance-terminate
### instance-termination-protection
### instance-termination-protection-disable
### instance-termination-protection-enable
### instance-type
### instance-userdata
### instance-volumes
### instance-vpc
### instances


## keypair-functions

List, create and delete EC2 SSH Keypairs

### keypairs
### keypair-create
### keypair-delete


## lambda-functions

### lambda-functions
### lambda-function-memory
### lambda-function-memory-set
### lambda-function-memory-step


### launch-configuration-asgs
### launch-configurations
### log-groups
### pcxs
### rds-db-instances


## region-functions

### regions

List regions

### region

Set $AWS_DEFAULT_REGION shell environment variable

### region-each

Run a command in every region. Any output lines will be appended with "#${REGION}".


### sts-assume-role
### subnets

## vpc-functions

### vpc-az-count
### vpc-azs
### vpc-default-delete
### vpc-dhcp-options-ntp
### vpc-endpoints
### vpc-igw
### vpc-lambda-functions
### vpc-nat-gateways
### vpc-network-acls
### vpc-rds
### vpc-route-tables
### vpc-subnets
### vpcs

## Internal functions
__bma_error
__bma_read_filters
__bma_read_inputs
__bma_read_stdin
__bma_usage
_bma_derive_params_from_stack_and_template
_bma_derive_params_from_template
_bma_derive_stack_from_params
_bma_derive_stack_from_template
_bma_derive_template_from_params
_bma_derive_template_from_stack
_bma_stack_args
_bma_stack_capabilities
_bma_stack_diff_params
_bma_stack_diff_template
_bma_stack_name_arg
_bma_stack_params_arg
_bma_stack_template_arg

