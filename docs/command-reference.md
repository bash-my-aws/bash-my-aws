
!!! Note "General Rules"
    - Commands expect that `$AWS_DEFAULT_REGION` is set (check/set with `region` command)
    - Most commands that list resources (`stacks`, `instances , etc) accept filter term as first arg.
        - *e.g. `stacks blah` is equivalent to `stacks | grep blah`*
    - Most commands accept resource identifiers via STDIN (first token of each line)
    - Resources are generally listed in chronological order of creation.


## aws-account-commands

These functions target AWS Accounts and act on either the account you're
authenticated to or the Account IDs provided to them.

### aws-account-alias

Retrieve AWS Account Alias for current account

```shell
$ aws-account-alias
example-account-prod
```

### aws-account-id

Retrieve AWS Account ID for current account

```shell
$ aws-account-id
012345678901
```

### aws-account-cost-explorer

Use with an AWS Organisations Master Account to open multiple accounts in Cost Explorer

```shell
$ grep demo AWS_ACCOUNTS | aws-account-cost-explorer
#=> Opens web browser to AWS Cost Explorer with accounts selected
```


### aws-account-cost-recommendations

Use with an AWS Organisations Master Account to open multiple accounts in Cost Recommendations

```shell
$ grep non_prod AWS_ACCOUNTS | aws-account-each stacks FAILED
#=> Opens web browser to AWS Cost Recommendations with accounts selected
```

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

!!! Note
    In order to use `aws-account-each`, you need to be authenticated with an
    IAM Role that can assume a Role in each of the specified accounts.
    Check the source for more info.


## region-commands

### regions

List regions

```shell
$ regions
ap-northeast-1
ap-northeast-2
ap-south-1
ap-southeast-1
ap-southeast-2
ca-central-1
cn-north-1
eu-central-1
eu-west-1
eu-west-2
sa-east-1
us-east-1
us-east-2
us-gov-west-1
us-west-1
us-west-2
```

### region

Get/Set `$AWS_DEFAULT_REGION` shell environment variable

```shell
$ region
us-east-1
$ region ap-southeast-2
$ region
ap-southeast-2
```


### region-each

Run a command in every region. Any output lines will be appended with "#${REGION}".

```shell
$ region-each stacks | column -t
example-ec2-ap-northeast-1  CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #ap-northeast-1
example-ec2-ap-northeast-2  CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #ap-northeast-2
example-ec2-ap-south-1      CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #ap-south-1
example-ec2-ap-southeast-1  CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #ap-southeast-1
example-ec2-ap-southeast-2  CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #ap-southeast-2
example-ec2-ca-central-1    CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #ca-central-1
example-ec2-eu-central-1    CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #eu-central-1
example-ec2-eu-west-1       CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #eu-west-1
example-ec2-eu-west-2       CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #eu-west-2
example-ec2-sa-east-1       CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #sa-east-1
example-ec2-us-east-1       CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #us-east-1
example-ec2-us-east-2       CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #us-east-2
example-ec2-us-west-1       CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #us-west-1
example-ec2-us-west-2       CREATE_COMPLETE  2011-05-23T15:47:44Z  NEVER_UPDATED  NOT_NESTED  #us-west-2
```



## stack-commands

Act on CloudFormation stacks.

This was where `bash-my-aws` started back in 2014. A few of these functions do not yet
accept multiple stacks as piped input.

### stacks

List CloudFormation stacks.

```shell
$ stacks
nagios          CREATE_COMPLETE  2018-03-12T11:41:31Z  NEVER_UPDATED  NOT_NESTED
postgres01      CREATE_COMPLETE  2019-04-14T15:22:44Z  NEVER_UPDATED  NOT_NESTED
postgres02      CREATE_COMPLETE  2019-05-18T05:45:50Z  NEVER_UPDATED  NOT_NESTED
prometheus-web  CREATE_COMPLETE  2019-11-23T15:57:04Z  NEVER_UPDATED  NOT_NESTED
```

*Optionally provide a filter string for a `| grep` effect with tighter columisation:*

```shell
$ stacks postgres
postgres01  CREATE_COMPLETE  2019-04-14T15:22:44Z  NEVER_UPDATED  NOT_NESTED
postgres02  CREATE_COMPLETE  2019-05-18T05:45:50Z  NEVER_UPDATED  NOT_NESTED
```


### stack-arn

`USAGE: stack-arn stack [stack]`

Returns ARN(s) for stacks.

```shell
$ stack-arn nagios prometheus-web
arn:aws:cloudformation:us-east-1:000000000000:stack/prometheus-web/805e081c-b8eb-4f6c-9872-2b5cddc77fba
```

*Supports multiple stack names from STDIN*:

```shell
$ stacks | stack-arn
arn:aws:cloudformation:us-east-1:000000000000:stack/nagios/c0f0ef04-b505-4c0c-87cd-ca924153ad1c
arn:aws:cloudformation:us-east-1:000000000000:stack/postgres01/758b0ba2-60f2-4432-8935-f79f47708f23
arn:aws:cloudformation:us-east-1:000000000000:stack/postgres02/7420bbd4-3026-444f-b55b-fa0a9d564730
arn:aws:cloudformation:us-east-1:000000000000:stack/prometheus-web/805e081c-b8eb-4f6c-9872-2b5cddc77fba
```


### stack-asg-instances

`USAGE: stack-asg-instances stack [stack]`

```shell
$ stacks | stack-asg-instances
i-06ee900565652ecc5  ami-0119aa4d67e59007c  t3.nano  running  asg-bash-my-aws  2019-12-13T03:15:22.000Z  ap-southeast-2c  vpc-deb8edb9
i-01c7edb986c18c16a  ami-0119aa4d67e59007c  t3.nano  running  asg2             2019-12-13T03:37:51.000Z  ap-southeast-2c  vpc-deb8edb9
```


### stack-asgs

`USAGE: stack-asgs stack [stack]`

```shell
$ stacks | stack-asgs
asg-bash-my-aws-AutoScalingGroup-MSBCWRTI3PVM  AWS::AutoScaling::AutoScalingGroup  asg-bash-my-aws
asg2-AutoScalingGroup-1FHUVUJ7SLPU7            AWS::AutoScaling::AutoScalingGroup  asg2
```


### stack-cancel-update
### stack-create
### stack-delete
### stack-diff


### stack-elbs

`USAGE: stack-elbs stack [stack]`

```shell
$ stacks | stack-elbs
elb-MyLoadBalancer-NA5S72MLA5KI   AWS::ElasticLoadBalancing::LoadBalancer  elb-stack-1
load-bala-MyLoadBa-11HZ0DHUHJZZI  AWS::ElasticLoadBalancing::LoadBalancer  elb-stack-2
```


### stack-events
### stack-exports
### stack-failure


### stack-instances

`USAGE: stack-instances stack [stack]`

```shell
$ stacks | stack-instances
i-7d54924538baa7a1f  ami-123456789012  t3.nano  stopped  ec2             2019-12-11T09:31:03.000Z  ap-southeast-2a  None
i-c54279c6055c3c794  ami-123456789012  t3.nano  running  nagios          2019-12-13T02:24:30.000Z  ap-southeast-2a  None
i-a8b8dd6783e1a40cc  ami-123456789012  t3.nano  running  postgres01      2019-12-13T02:24:32.000Z  ap-southeast-2a  None
i-5d74753e210bfe04d  ami-123456789012  t3.nano  running  postgres02      2019-12-13T02:24:34.000Z  ap-southeast-2a  None
i-2aa95cc214a461398  ami-123456789012  t3.nano  running  prometheus-web  2019-12-13T02:24:36.000Z  ap-southeast-2a  None
```


### stack-outputs
### stack-parameters
### stack-recreate


### stack-resources

`USAGE: stack-resources stack [stack]`

```shell
$ stacks | stack-resources
i-7d54924538baa7a1f  AWS::EC2::Instance  ec2
i-c54279c6055c3c794  AWS::EC2::Instance  nagios
i-a8b8dd6783e1a40cc  AWS::EC2::Instance  postgres01
i-5d74753e210bfe04d  AWS::EC2::Instance  postgres02
i-2aa95cc214a461398  AWS::EC2::Instance  prometheus-web
```


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


## instance-commands

These commands work with EC2 Instances. While the USAGE line describes command
line arguments, the examples tend to use STDIN to pass resource IDs because
it's more common usage.

### instances

Lists EC2 instances

```shell
$ instances
i-4e15ece1de1a3f869  ami-123456789012  t3.nano  running  nagios          2019-12-10T08:17:18.000Z  ap-southeast-2a  None
i-89cefa9403373d7a5  ami-123456789012  t3.nano  running  postgres01      2019-12-10T08:17:20.000Z  ap-southeast-2a  None
i-806d8f1592e2a2efd  ami-123456789012  t3.nano  running  postgres02      2019-12-10T08:17:22.000Z  ap-southeast-2a  None
i-61e86ac6be1e2c193  ami-123456789012  t3.nano  running  prometheus-web  2019-12-10T08:17:24.000Z  ap-southeast-2a  None
```

*Optionally provide a filter string for a `| grep` effect with tighter columisation:*
```shell
$ instances postgres
i-89cefa9403373d7a5  ami-123456789012  t3.nano  running  postgres01  2019-12-10T08:17:20.000Z  ap-southeast-2a  None
i-806d8f1592e2a2efd  ami-123456789012  t3.nano  running  postgres02  2019-12-10T08:17:22.000Z  ap-southeast-2a  None
```

### instance-asg

### instance-az

List Availability Zone(s) for EC2 Instance(s)

`USAGE: instance-az instance-id [instance-id]`

```shell
$ instances postgres | instance-az
i-89cefa9403373d7a5  ap-southeast-2a
i-806d8f1592e2a2efd  ap-southeast-2a
```

### instance-console

`USAGE: instance-console instance-id [instance-id]`

```shell
$ instances postgres | instance-console
Console output for EC2 Instance i-89cefa9403373d7a5
Linux version 2.6.16-xenU (builder@patchbat.amazonsa) (gcc version 4.0.1 20050727 (Red Hat 4.0.1-5)) #1 SMP Thu Oct 26 08:41:26 SAST 2006
BIOS-provided physical RAM map:
Xen: 0000000000000000 - 000000006a400000 (usable)
980MB HIGHMEM available.
727MB LOWMEM available.
NX (Execute Disable) protection: active
IRQ lockup detection disabled
Built 1 zonelists
Kernel command line: root=/dev/sda1 ro 4
Enabling fast FPU save and restore... done.


Console output for EC2 Instance i-806d8f1592e2a2efd
Linux version 2.6.16-xenU (builder@patchbat.amazonsa) (gcc version 4.0.1 20050727 (Red Hat 4.0.1-5)) #1 SMP Thu Oct 26 08:41:26 SAST 2006
BIOS-provided physical RAM map:
Xen: 0000000000000000 - 000000006a400000 (usable)
980MB HIGHMEM available.
727MB LOWMEM available.
NX (Execute Disable) protection: active
IRQ lockup detection disabled
Built 1 zonelists
Kernel command line: root=/dev/sda1 ro 4
Enabling fast FPU save and restore... done.
```


### instance-dns

Get DNS entries for EC2 instances

`USAGE: instance-dns instance-id [instance-id]`

```shell
$ instances postgres | instance-dns
i-89cefa9403373d7a5  ip-10-155-35-61.ap-southeast-2.compute.internal   ec2-54-214-206-114.ap-southeast-2.compute.amazonaws.com
i-806d8f1592e2a2efd  ip-10-178-243-63.ap-southeast-2.compute.internal  ec2-54-214-244-90.ap-southeast-2.compute.amazonaws.com
```


### instance-iam-profile


### instance-ip

Get IP Addresses for EC2 instances

`USAGE: instance-ip instance-id [instance-id]`

    $ instances postgres | instance-ip
    i-89cefa9403373d7a5  10.155.35.61   54.214.206.114
    i-806d8f1592e2a2efd  10.178.243.63  54.214.244.90


### instance-ssh
### instance-ssh-details

### instance-stack

`USAGE: instance-stack instance-id [instance-id]`

    $ instances postgres | instance-stack
    postgres01  i-89cefa9403373d7a5
    postgres02  i-806d8f1592e2a2efd


### instance-start

Start some existing stopped EC2 instances.

`USAGE: instance-stop instance-id [instance-id]`

    $ instances postgres | instance-start
    i-a8b8dd6783e1a40cc  PreviousState=stopped  CurrentState=pending
    i-5d74753e210bfe04d  PreviousState=stopped  CurrentState=pending


### instance-state

Get current state of instances.

`USAGE: instance-state instance-id [instance-id]`

    $ instances postgres | instance-state
    i-89cefa9403373d7a5  running
    i-806d8f1592e2a2efd  running

*You could also just get this from `instances` command:*

    $ instances postgres
    i-89cefa9403373d7a5  ami-123456789012  t3.nano  running  postgres01  2019-12-10T08:17:20.000Z  ap-southeast-2a  None
    i-806d8f1592e2a2efd  ami-123456789012  t3.nano  running  postgres02  2019-12-10T08:17:22.000Z  ap-southeast-2a  None


### instance-stop

Stop EC2 instances

`USAGE: instance-stop instance-id [instance-id]`

    $ instances postgres | instance-stop

    i-a8b8dd6783e1a40cc  PreviousState=running  CurrentState=stopping
    i-5d74753e210bfe04d  PreviousState=running  CurrentState=stopping


### instance-tags


### instance-terminate

Terminate EC2 instance.

*This could probably do with some line oriented output.*

`USAGE: instance-terminate instance-id [instance-id]`

    $ instances | head -1 | instance-terminate
    You are about to terminate the following instances:
    i-4e15ece1de1a3f869  ami-123456789012  t3.nano  running  nagios  2019-12-10T08:17:18.000Z  ap-southeast-2a  None
    Are you sure you want to continue? y

    {
        "TerminatingInstances": [
            {
                "CurrentState": {
                    "Code": 32,
                    "Name": "shutting-down"
                },
                "InstanceId": "i-4e15ece1de1a3f869",
                "PreviousState": {
                    "Code": 16,
                    "Name": "running"
                }
            }
        ]
    }



### instance-termination-protection

`USAGE: instance-termination-protection instance-id [instance-id]`

    $ instances | instance-termination-protection
    i-4e15ece1de1a3f869	DisableApiTermination=true
    i-89cefa9403373d7a5	DisableApiTermination=false
    i-806d8f1592e2a2efd	DisableApiTermination=false
    i-61e86ac6be1e2c193	DisableApiTermination=false


### instance-termination-protection-disable

`USAGE: instance-termination-protection-disable instance-id [instance-id]`


### instance-termination-protection-enable

`USAGE: instance-termination-protection-enable instance-id [instance-id]`


### instance-type

List instance type for instances. *You could also just view output of `instances` command*

`USAGE: instance-type instance-id [instance-id]`

```shell
$ instances | instance-type
i-4e15ece1de1a3f869  t3.nano
i-89cefa9403373d7a5  t3.nano
i-806d8f1592e2a2efd  t3.nano
i-61e86ac6be1e2c193  t3.nano
```


### instance-userdata


### instance-volumes

`USAGE: instance-volumes instance-id [instance-id]`

    $ instances postgres | instance-volumes
    i-89cefa9403373d7a5  vol-cf5ddae9
    i-806d8f1592e2a2efd  vol-38fd45c3


### instance-vpc

`USAGE: instance-vpc instance-id [instance-id]`


## bucket-commands

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

Remove an empty S3 Bucket.

*In this example the bucket is not empty.*

```shell
$ bucket-remove another-example-bucket
You are about to remove the following buckets:
another-example-bucket  2019-12-07  06:51:12.022496
Are you sure you want to continue? y
remove_bucket failed: s3://another-example-bucket An error occurred (BucketNotEmpty) when calling the DeleteBucket operation: The bucket you tried to delete is not empty
```


### bucket-remove-force

Remove an S3 Bucket, and delete all objects if it's not empty.

```shell
$ bucket-remove-force another-example-bucket
You are about to delete all objects from and remove the following buckets:
another-example-bucket  2019-12-07  06:51:12.022496
Are you sure you want to continue? y
delete: s3://another-example-bucket/aliases
remove_bucket: another-example-bucket
```


## cert-commands

ACM Certificates

### certs
### cert-delete
### cert-users
### certs-arn


## ecr-commands

### ecr-repositories
### ecr-repository-images


## elb-commands

### elb-dnsname
### elb-instances
### elb-stack
### elbs


## iam-commands

### iam-role-principal
### iam-roles


## keypair-commands

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


## vpc-commands

### vpcs

List VPCs

    $ vpcs
    vpc-018d9739  default-vpc  NO_NAME  172.31.0.0/16  NO_STACK  NO_VERSION


### vpc-az-count

List number of Availability Zones for VPCs

`USAGE: vpc-az-count vpc-id [vpc-id]`

    $ vpcs | vpc-az-count
    vpc-018d9739 3


### vpc-azs

List availability zones for VPCs

$ vpc-azs
USAGE: vpc-azs vpc-id [vpc-id]

    $ vpcs | vpc-azs
    vpc-018d9739 ap-southeast-2a ap-southeast-2b ap-southeast-2c


### vpc-default-delete

Prints commands you would need to run to delete that pesky default VPC

    $ vpc-default-delete

    # Deleting default VPC vpc-018d9739 in ap-southeast-2
    aws --region ap-southeast-2 ec2 delete-subnet --subnet-id=subnet-8bb774fe
    aws --region ap-southeast-2 ec2 delete-subnet --subnet-id=subnet-9eea2c07
    aws --region ap-southeast-2 ec2 delete-subnet --subnet-id=subnet-34fd9cfa
    aws --region ap-southeast-2 ec2 delete-vpc --vpc-id=vpc-018d9739


### vpc-dhcp-options-ntp
### vpc-endpoints
### vpc-igw
### vpc-lambda-commands


### vpc-nat-gateways

`USAGE: vpc-nat-gateways vpc-id [vpc-id]`


### vpc-network-acls

`USAGE: vpc-network-acls vpc-id [vpc-id]`

    $ vpcs | vpc-network-acls
    acl-ff4914d1  vpc-018d9739


### vpc-rds


### vpc-route-tables

`USAGE: vpc-route-tables vpc-id [vpc-id]`

    $ vpcs | vpc-route-tables
    rtb-8e841c39  vpc-018d9739  NO_NAME


### vpc-subnets

List subnets for vpcs

`USAGE: vpc-subnets vpc-id [vpc-id]`

    $ vpcs | vpc-subnets
    subnet-34fd9cfa  vpc-018d9739  ap-southeast-2c  172.31.32.0/20  NO_NAME
    subnet-8bb774fe  vpc-018d9739  ap-southeast-2a  172.31.0.0/20   NO_NAME
    subnet-9eea2c07  vpc-018d9739  ap-southeast-2b  172.31.16.0/20  NO_NAME

### pcxs

### subnets

List all subnets

    $ subnets
    subnet-34fd9cfa  vpc-018d9739  ap-southeast-2c  172.31.32.0/20  NO_NAME
    subnet-8bb774fe  vpc-018d9739  ap-southeast-2a  172.31.0.0/20   NO_NAME
    subnet-9eea2c07  vpc-018d9739  ap-southeast-2b  172.31.16.0/20  NO_NAME


## asg-commands

### asgs
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

### launch-configurations
### launch-configuration-asgs


## lambda-commands

### lambda-commands
### lambda-function-memory
### lambda-function-memory-set
### lambda-function-memory-step

## Other
### cloudtrails
### cloudtrail-status
### columnise
### image-deregister
### images
### log-groups
### rds-db-instances
### sts-assume-role


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

