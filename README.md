![TravisCI](https://api.travis-ci.org/realestate-com-au/bash-my-aws.svg)

bash-my-aws
===========

Written to make my life easier, bash-my-aws assists Infrastructure Jockeys using 
Amazon Web Services from the command line.

This project provides easily memorable commands for realtime control of resources
in Amazon AWS. The goal is to reduce the time between intention and effect.

The functions are just as happy being called from your scripts as they are being
tapped out on the keyboard.

They make extensive use of the incredibly powerful AWSCLI. It's hoped they may
also provide a useful reference to its use.


## Prerequisites

* bash
* [awscli](http://aws.amazon.com/cli/)
* jp (installed automatically if you used python-pip to install awscli)
* [jq-1.4](http://stedolan.github.io/jq/download/) or later (for the cf_diff function)


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
$ source <(~/.bash-my-aws/bin/generate_bash_completion)
```

Typing stack[TAB][TAB] will list available functions for CloudFormation:

```ShellSession
$ stack
stack             stack-elbs        stack-parameters  stack-update
stack-asgs        stack-events      stack-resources   stack-validate
stack-create      stack-failure     stack-status      stacks
stack-delete      stack-instances   stack-tail
stack-diff        stack-outputs     stack-template
```

Omitting required arguments will result in Usage instructions being displayed:
```
$ cf_get
Usage: cf_get stack
```

For more info on the query syntax used by AWSCLI, check out http://jmespath.org/tutorial.html


### Usage examples

**cloudformation-functions**

#### Create a stack

This function gives you tab completion for filenames (missing from AWSCLI).

```
$ cf_create
Usage: cf_create stack [template-file] [params-file]

$ cf_create example      # creates stack called example using example.json
```

It's also one of the functions that allows you to omit the template name
if it exists in the current directory and matches the stack name with '.json'
appended.

It's even smart enough to detect that you've added '-blah' to the stack name.
```
$ cf_create example-test # creates stack called example-test using example.json
```


#### List stacks

This is basically 'ls' with the ability to filter by a search string

```
$ cf_list example # call without filter argument to return all stacks
example-app
example-app-test
example-app-dev
```


#### See what changes will be made by updating a stack
```
$ cf_diff
Usage: cf_diff stack [template-file]

$ cf_diff example
--- /dev/fd/63  2014-12-24 15:12:33.000000000 +1100
+++ /dev/fd/62  2014-12-24 15:12:33.000000000 +1100
@@ -113,7 +113,7 @@
         "t2.micro",
         "t2.small"
       ],
-      "Default": "m3.large",
+      "Default": "m3.small",
       "Description": "The type of the EC2 instance you want",
       "Type": "String"
     },
```


#### Update a stack
```
$ cf_update
Usage: cf_update stack [template-file] [params-file]

$ cf_update example # creates stack called example using example.json 
...
```


#### Delete a stack
```
$ cf_delete
Usage: cf_delete stack

$ cf_delete example # deletes stack called example
...
```


#### Tail stack events

The create/update tasks call this one but it can also be called directly.
It watches events for a stack until it sees them complete or fail.

```
$ cf_tail who-is-my-am
----------------------------------------------------------------------
|                         DescribeStackEvents                        |
+--------------+----------------------+------------------------------+
|   Resource   |       Status         |            Type              |
+--------------+----------------------+------------------------------+
|  who-is-my-am|  CREATE_IN_PROGRESS  |  AWS::CloudFormation::Stack  |
|  S3Bucket    |  CREATE_COMPLETE     |  AWS::S3::Bucket             |
|  BucketPolicy|  CREATE_COMPLETE     |  AWS::S3::BucketPolicy       |
|  DNS         |  CREATE_COMPLETE     |  AWS::Route53::RecordSet     |
|  who-is-my-am|  CREATE_COMPLETE     |  AWS::CloudFormation::Stack  |
+--------------+----------------------+------------------------------+
```
