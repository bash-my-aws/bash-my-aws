# Getting Started

`bash-my-aws` is a set of powerful yet simple command line tools for managing
Amazon Web Services.

They wrap AWSCLI and provide a number of advantages that include:

- short, memorable commands
- bash completion (including AWS resources)
- text output (instead of JSON)
- the ability to pipe output between commands


## Prerequisites

* [awscli](http://aws.amazon.com/cli/)
* [bash](https://www.gnu.org/software/bash/)
* [jq-1.4](http://stedolan.github.io/jq/download/) or later (for stack-diff)


## Installation

As shown below, you may simply clone the GitHub repo and source the files required.
(You should probably fork it instead to keep your customisations)

```Shell
$ git clone https://github.com/bash-my-universe/bash-my-aws.git ~/.bash-my-aws
```

Put the following in your shell's startup file:

```Shell
export PATH="$PATH:$HOME/.bash-my-aws/bin"
source ~/.bash-my-aws/aliases

# For ZSH users, uncomment the following two lines:
# autoload -U +X compinit && compinit
# autoload -U +X bashcompinit && bashcompinit

source ~/.bash-my-aws/bash_completion.sh
```

!!! note "Why use shell aliases?"

    `bash-my-aws` began as a collection of bash functions, sourced into your shell.
    More recently, the default suggestion has been to load aliases that execute a
    small wrapper script that loads the functions and executes the desired function.

    After years of `zsh` users asking for support, one stepped up and identified
    a changes that would eliminate any shell compatibility problems without compromising
    the functionaility, simplicity and discoverability of the project. Massive thanks
    to @ninth-dev for this.

    Bash users can still source the functions instead of loading the aliases:

      ```
      # bash users may source the functions instead of loading the aliases
      if [ -d ${HOME}/.bash-my-aws ]; then
        for f in ~/.bash-my-aws/lib/*-functions; do source $f; done
      fi
      ```


## Quickstart

Authenticate the same way you would to use AWSCLI commands.

```shell
$ stacks
blah
blah
blah
```

```shell
$ instances
```


## Usage


### Running the commands

The default way to run the commands is using the aliases:

```ShellSession
$ instances
```

It's also possible to run them using the `bma` wrapper.
(This is sometimes required when using a restrictive auth tool.)

```ShellSession
$ bma instances
```

### Discovering the Commands

For each resource type, there is a command to list them:

```shell
$ instances
foo DDDDDDDDDDDDDDDD
bar EEEEEEEEEEEEEEEE
```

and a number of command to act on these resources:

```ShellSession
$ instance-[TAB][TAB]
instance-asg          instance-ssh-details  instance-termination-protection
instance-az           instance-stack        instance-termination-protection-disable
instance-console      instance-start        instance-termination-protection-enable
instance-dns          instance-state        instance-type
instance-iam-profile  instance-stop         instance-userdata
instance-ip           instance-tags         instance-volumes
instance-ssh          instance-terminate    instance-vpc
```

Whether you're new to the tools or just have a bad memory, bash completion
makes discovering these commands simple.

!!! Note "See the [Functions](/commands) page for a full list with usage examples"


### Piping Between Commands

This is where the magic happens!

The first token on each line is almost always a resource identifier. When you pipe output
between the commands they just take the first token from each line.

```ShellSession
$ instances | grep splunk | instance-stack | stack-status
splunk-forwarder      UPDATE_COMPLETE
splunk-forwarder-role CREATE_COMPLETE
```


### Inspecting the commands

For those interested in how it works:

- Each command is a bash function.
- Most are *very* simple and wrap an AWSCLI command.

For a quick look at how a command works, you can use `bma type`:

```shell
$ bma type instances
instances is a function
instances () 
{ 
    local instance_ids=$(__bma_read_inputs);
    local filters=$(__bma_read_filters $@);
    aws ec2 describe-instances $([[ -n ${instance_ids} ]] && echo --instance-ids ${instance_ids}) --query "
      Reservations[].Instances[][
        InstanceId,
        ImageId,
        InstanceType,
        State.Name,
        [Tags[?Key=='Name'].Value][0][0],
        LaunchTime,
        Placement.AvailabilityZone,
        VpcId
      ]" --output text | grep -E -- "$filters" | LC_ALL=C sort -b -k 6 | column -s'	' -t
}
```

A prettier version can be found in the source code:

```shell
# ~/.bash-my-aws/lib/instance-functions
instances() {
  local instance_ids=$(__bma_read_inputs)
  local filters=$(__bma_read_filters $@)

  aws ec2 describe-instances                                            \
    $([[ -n ${instance_ids} ]] && echo --instance-ids ${instance_ids})  \
    --query "
      Reservations[].Instances[][
        InstanceId,
        ImageId,
        InstanceType,
        State.Name,
        [Tags[?Key=='Name'].Value][0][0],
        LaunchTime,
        Placement.AvailabilityZone,
        VpcId
      ]"                                                               \
    --output text       |
  grep -E -- "$filters" |
  LC_ALL=C sort -b -k 6 |
  column -s$'\t' -t
}
```

For more info on AWSCLI query syntax, check out [http://jmespath.org/tutorial.html](http://jmespath.org/tutorial.html)
