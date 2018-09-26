bash-my-aws
===========

bash-my-aws assists Infrastructure Jockeys using Amazon Web Services from the
command line.

This project provides short, memorable commands for realtime control of
resources in Amazon AWS. The goal is to reduce the time between intention and
effect.

These functions make extensive use of the incredibly powerful AWSCLI.

## Prerequisites

* [awscli](http://aws.amazon.com/cli/)
* [bash](https://www.gnu.org/software/bash/)
* [jq-1.4](http://stedolan.github.io/jq/download/) or later (for stack-diff)


## Installation

As shown below, you may simply clone the GitHub repo and source the files required.
(You should probably fork it instead to keep your customisations)

```ShellSession
$ git clone https://github.com/realestate-com-au/bash-my-aws.git ~/.bash-my-aws
```


## Usage

Source the functions with something like:
```ShellSession
$ for f in ~/.bash-my-aws/lib/*-functions; do source $f; done
```

Add the bash_completion scripts: (optional)
```ShellSession
$ source ~/.bash-my-aws/bash_completion.sh
```

**Typing stack[TAB][TAB] will list available functions for CloudFormation:**

```ShellSession
$ stacks # lists CloudFormation stacks

$ stack-[TAB][TAB]
stack-arn            stack-elbs           stack-recreate       stack-tags-text
stack-asg-instances  stack-events         stack-resources      stack-tail
stack-asgs           stack-exports        stack-status         stack-template
stack-cancel-update  stack-failure        stack-tag            stack-update
stack-create         stack-instances      stack-tag-apply      stack-validate
stack-delete         stack-outputs        stack-tag-delete     
stack-diff           stack-parameters     stack-tags   

$ asgs # lists Autoscaling groups

$ asg-[TAB][TAB]
asg-capacity             asg-min-size-set         asg-stack
asg-desired-size-set     asg-processes_suspended  asg-suspend
asg-instances            asg-resume               
asg-max-size-set         asg-scaling-activities  

$ buckets # lists S3 buckets
bucket-acls   

$ elbs # lists Elastic Load Balancers (classic)
$ elb-[TAB][TAB]
elb-dnsname    elb-instances 

$ instances # lists EC2 instances

$ instance-[TAB][TAB]
instance-asg                             instance-stop
instance-az                              instance-tags
instance-console                         instance-terminate
instance-dns                             instance-termination-protection
instance-iam-profile                     instance-termination-protection-disable
instance-ip                              instance-termination-protection-enable
instance-ssh                             instance-type
instance-ssh-details                     instance-userdata
instance-stack                           instance-volumes
instance-start                           instance-vpc
instance-state                            

$ keypairs # lists EC2 SSH KeyPairs

$ keypair-[TAB][TAB]
keypair-create  keypair-delete 

$ vpcs $ lists VPCs

$ vpc-[TAB][TAB]
vpc-default-delete    vpc-lambda-functions  vpc-rds
vpc-dhcp-options-ntp  vpc-nat-gateways      vpc-route-tables
vpc-igw               vpc-network-acls      vpc-subnets

```

For more info on the query syntax used by AWSCLI, check out http://jmespath.org/tutorial.html

**Piping output between functions**

We're very excited to announce this functionality.  

Most bash-my-aws functions will accept AWS Resource Ids from STDIN. This means
you can pipe output from many functions into other functions.

```ShellSession
$ instances | grep splunk | instance-stack | stack-status
splunk-forwarder  UPDATE_COMPLETE
splunk-forwarder-role CREATE_COMPLETE
```


### Usage examples

**cloudformation-functions**

#### Create a stack

This function gives you tab completion for filenames (missing from AWSCLI).

```ShellSession
$ stack-create
USAGE: stack-create stack

$ stack-create example      # creates stack called example using example.json
```

It's also one of the functions that allows you to omit the template name
if it exists in the current directory and matches the stack name with '.json'
appended.

It's even smart enough to detect that you've added '-blah' to the stack name.
```ShellSession
$ stack-create example-test # creates stack called example-test using example.json
```


#### List stacks

This is basically 'ls' with the ability to filter by a search string

```ShellSession
$ stacks # call without filter argument to return all stacks
example-app
example-app-test
example-app-dev
something
something-else

$ stacks example # Or filter out the relevant stacks
example-app
example-app-test
example-app-dev
```


#### See what changes will be made by updating a stack
```ShellSession
$ stack-diff
USAGE: stack-diff stack [template-file]

$ stack-diff example-dev
template for stack (example) and contents of file (example-dev.json) are the same

e--- params
+++ example-params-dev.json
@@ -4,7 +4,7 @@
         "ParameterKey": "slipGeneratorRolePath"
     },
     {
-        "ParameterValue": "something",
+        "ParameterValue": "something-else",
         "ParameterKey": "storageBucketName"
     },
     {
```

#### Updating a stack

```ShellSession
$ stack-update
USAGE: stack-update stack [template-file] [params-file]

$ stack-update example # creates stack called example using example.json
...
```


#### Deleting a stack

```ShellSession
$ stack-delete
USAGE: stack-delete stack

$ stack-delete example # deletes stack called example
...
```


#### Tailing stack events

The create/update tasks call this one but it can also be called directly.
It watches events for a stack until it sees them complete or fail.

```ShellSession
$ stack-tail my-stack
---------------------------------------------------------------------------------------------------------------------------------------------------------
|                                                                  DescribeStackEvents                                                                  |
+--------------------------+-------------------------------+-------------------------------------------+------------------------------------------------+
|  2015-07-25T23:13:21.628Z|  MyStack                      |  AWS::CloudFormation::Stack               |  CREATE_IN_PROGRESS                            |
|  2015-07-25T23:13:27.221Z|  AppServerSSHSecurityGroup    |  AWS::EC2::SecurityGroup                  |  CREATE_IN_PROGRESS                            |
|  2015-07-25T23:13:27.235Z|  DeploymentSQSQueue           |  AWS::SQS::Queue                          |  CREATE_IN_PROGRESS                            |
|  2015-07-25T23:13:27.291Z|  InternalELBSecurityGroup     |  AWS::EC2::SecurityGroup                  |  CREATE_IN_PROGRESS                            |
|  2015-07-25T23:13:27.537Z|  AppServerRole                |  AWS::IAM::Role                           |  CREATE_IN_PROGRESS                            |
|  2015-07-25T23:13:28.244Z|  DeploymentSQSQueue           |  AWS::SQS::Queue                          |  CREATE_IN_PROGRESS                            |
|  2015-07-25T23:13:28.769Z|  DeploymentSQSQueue           |  AWS::SQS::Queue                          |  CREATE_COMPLETE                               |
+--------------------------+-------------------------------+-------------------------------------------+------------------------------------------------+
```

