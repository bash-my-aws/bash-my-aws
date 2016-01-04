[![TravisCI](https://api.travis-ci.org/realestate-com-au/bash-my-aws.svg)](https://travis-ci.org/realestate-com-au/bash-my-aws/builds)

bash-my-aws
===========

![caveman](./doc/caveman.jpg)

** 22 Nov 2015 - In breaking (change) news, we're proud to release the complete rework! **

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

Source the functions you want with something like:
```ShellSession
$ for f in ~/.bash-my-aws/lib/*-functions; do source $f; done
```

Add the bash_completion scripts: (optional)
```ShellSession
$ source ~/.bash-my-aws/bash_completion.sh
```

**Typing stack[TAB][TAB] will list available functions for CloudFormation:**

```ShellSession
$ stack
stack             stack-elbs        stack-parameters  stack-update
stack-asgs        stack-events      stack-resources   stack-validate
stack-create      stack-failure     stack-status      stacks
stack-delete      stack-instances   stack-tail
stack-diff        stack-outputs     stack-template

$ instance
instance-asg          instance-ip           instance-start        instance-terminate    instances
instance-console      instance-ssh          instance-state        instance-type
instance-dns          instance-ssh-details  instance-stop         instance-userdata
instance-iam-profile  instance-stack        instance-tags         instance-volumes

$ asg
asg-capacity             asg-instances
asg-processes_suspended
asg-cpu                  asg-ips                  asg-resume
asg-desired-size-set     asg-max-size-set         asgs
asg-elb                  asg-min-size-set         asg-suspend
```

For more info on the query syntax used by AWSCLI, check out http://jmespath.org/tutorial.html

** Piping output between functions **

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


### Advanced Options

#### Output Style

The `bash-my-aws` commands support all the outputs of `awscli`. As of version
1.7.36, the supported outputs are `json`, `tables`, or `text`.

`bash-my-aws` supports a shorthand switch of `--json`, `--tables`, or `--text`.

