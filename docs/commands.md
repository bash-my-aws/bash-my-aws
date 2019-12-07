- commands expect that AWS_DEFAULT_REGION is set
  - check/set with `region`
  - list all with `regions`
  - run and command across all regions with `region-each`
- all resource list commands (stacks, instances, etc) filter on first arg
  - `stacks blah` is equivalent to `stacks | grep blah`
- commands assume first token of each line of STDIN to be resource identifiers
- resources are generally listed in order of creation date
  - most recently created resources will be closest to your flashing cursor




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

List S3 Buckets

```shell
$ buckets
example-bucket          2019-12-07  06:51:05.064372
another-example-bucket  2019-12-07  06:51:12.022496
```

### bucket-acls

List S3 Bucket Access Control Lists.

```shell
$ bucket-acls another-example-bucket
another-example-bucket
```

!!! Note
    The only recommended use case for the bucket ACL is to grant write
    permission to the Amazon S3 Log Delivery group to write access log objects to
    your bucket. [AWS docs](https://docs.aws.amazon.com/AmazonS3/latest/dev/access-policy-alternatives-guidelines.html)

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

List EC2 SSH Keypairs in current Region

```shell
$ keypairs
alice  8f:85:9a:1e:6c:76:29:34:37:45:de:7f:8d:f9:70:eb
bob    56:73:29:c2:ad:7b:6f:b6:f2:f3:b4:de:e4:2b:12:d4
```

### keypair-create

Create SSH Keypair on local machine and import public key into new EC2 Keypair.

Provides benefits over AWS creating the keypair:

- Amazon never has access to private key
- Private key is protected with passphrase before being written to disk
- Keys is written to ~/.ssh with correct file permissions
- You control the SSH Key type (algorithm, length, etc)

```shell
$ keypair-create yet-another-keypair
Creating /home/m/.ssh/yet-another-keypair
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/m/.ssh/yet-another-keypair.
Your public key has been saved in /home/m/.ssh/yet-another-keypair.pub.
The key fingerprint is:
SHA256:zIpbxLo7rpQvKyezOLATk96B1kSL0QP41q6x8tUrySk m@localhost.localdomain
The key's randomart image is:
+---[RSA 4096]----+
|..o              |
|.. +             |
| .+.o            |
| .oo.. o         |
| o+.  o S        |
|=o.+.= .         |
|+++==o+          |
|XoE+*+ .         |
|o@+**+.          |
+----[SHA256]-----+
{
    "KeyFingerprint": "21:82:f9:5b:79:d6:dc:0f:7b:79:43:7c:c5:34:6c:2d",
    "KeyName": "yet-another-keypair"
}
```

!!! Note
    KeyPair Name defaults to "$(aws-account-alias)-$(region)" if none provided

### keypair-delete

Delete EC2 SSH Keypairs by providing their names as arguments or via STDIN

```shell
$ keypair-delete alice bob
You are about to delete the following EC2 SSH KeyPairs:
alice
bob
Are you sure you want to continue? y
```

```shell
$ keypairs | keypair-delete
You are about to delete the following EC2 SSH KeyPairs:
yet-another-keypair
Are you sure you want to continue? y
```


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

