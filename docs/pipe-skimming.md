title: Pipe-Skimming pattern for Unix CLI Tools - Bash-my-AWS
description: Pipe-Skimming allows expressive, line oriented text to be
    piped to commands that skim only the resource identifiers from each line.

Pipe-Skimming: Enhancing the UI of Unix CLI tools

<iframe width="560" height="315" src="https://www.youtube.com/embed/eqQUepwTHjA?start=631" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

When text is piped to a command that implements pipe-skimming, it appends
the first item from each line (STDIN) to its argument array (ARGV).

This allows for expressive line oriented output to be piped to commands
that will skim only the resource identifiers from each line.

This makes exploring and traversing related resources from the command
line a pleasure:

    $ stacks | grep nginx | stack-asgs | asg-instances | instance-state
    i-0e219fbee42347721  shutting-down

Pipe-skimming is simple to implement within commands and doesn't require
any changes to the command shell.


## How it Works

The following examples show commands from [Bash-my-AWS](https://bash-my-aws.org/),
the project from which this pattern was extracted.


### Usage Examples

Here we list EC2 Instances running in an Amazon AWS Account:

    $ instances
    i-09d962a1d688bb3ec  t3.nano   running  grafana-bma  2020-01-16T03:53:44.000Z
    i-083f73ad5a1895ba0  t3.small  running  huginn-bma   2020-01-16T03:54:24.000Z
    i-0e219fbee42347721  t3.nano   running  nginx-bma    2020-01-16T03:56:22.000Z


Piping output from this command into `instance-asg` returns a list of
AutoScaling Groups (ASGs) they belong to:

    $ instances | instance-asg
    huginn-bma-AutoScalingGroup-QS7EQOT1G7OX    i-083f73ad5a1895ba0
    nginx-bma-AutoScalingGroup-106KHAYHUSRHU    i-0e219fbee42347721
    grafana-bma-AutoScalingGroup-1NXJHMJVZQVMB  i-09d962a1d688bb3ec


While functionally identical, the example above is far easier to type
than this example using command arguments:

    $ instance-asg i-09d962a1d688bb3ec i-083f73ad5a1895ba0 i-0e219fbee42347721
    huginn-bma-AutoScalingGroup-QS7EQOT1G7OX    i-083f73ad5a1895ba0
    nginx-bma-AutoScalingGroup-106KHAYHUSRHU    i-0e219fbee42347721
    grafana-bma-AutoScalingGroup-1NXJHMJVZQVMB  i-09d962a1d688bb3ec


We can continue adding commands to our pipeline:

    $ instances | instance-asg | asg-capacity
    grafana-bma-AutoScalingGroup-1NXJHMJVZQVMB  1  1  2
    huginn-bma-AutoScalingGroup-QS7EQOT1G7OX    1  1  2
    nginx-bma-AutoScalingGroup-106KHAYHUSRHU    1  1  2


### Implementation in Bash-my-AWS

The command `instance-asg` (a Bash function) appends the first item
from each line of piped input on STDIN to its argument list:

    instance-asg() {

      # List autoscaling group membership of EC2 Instance(s)
      #
      #     USAGE: instance-asg instance-id [instance-id]

      local instance_ids=$(skim-stdin "$@")
      [[ -z $instance_ids ]] && __bma_usage "instance-id [instance-id]" && return 1

      aws ec2 describe-instances      \
        --instance-ids $instance_ids  \
        --output text                 \
        --query "
          Reservations[].Instances[][
            {
              "AutoscalingGroupName":
                [Tags[?Key=='aws:autoscaling:groupName'].Value][0][0],
              "InstanceId": InstanceId
            }
          ][]"          |
      column -s$'\t' -t
    }


This implementation uses a simple Bash function called `skim-stdin`:

    skim-stdin() {

      # Append first token from each line of STDIN to argument list
      #
      # Implementation of `pipe-skimming` pattern.
      #
      # Typical usage within Bash-my-AWS:
      #
      #   - local asg_names=$(skim-stdin "$@") # Append to arg list
      #   - local asg_names=$(skim-stdin)      # Only draw from STDIN
      #
      #     $ stacks | skim-stdin foo bar
      #     foo bar huginn mastodon grafana
      #
      #     $ stacks
      #     huginn    CREATE_COMPLETE  2020-01-11T06:18:46.905Z  NEVER_UPDATED  NOT_NESTED
      #     mastodon  CREATE_COMPLETE  2020-01-11T06:19:31.958Z  NEVER_UPDATED  NOT_NESTED
      #     grafana   CREATE_COMPLETE  2020-01-11T06:19:47.001Z  NEVER_UPDATED  NOT_NESTED

      (
        printf -- "$*"                           # Print all args
        printf " "                               # Print a space
        [[ -t 0 ]] || awk 'ORS=" " { print $1 }' # Print first token of each line of STDIN
      ) | awk '{$1=$1;print}'                    # Trim leading/trailing spaces
    }


Almost every command in [Bash-my-AWS](https://bash-my-aws.org) makes use of
`skim-stdin` to accept resource identifiers via arguments and/or piped input on
STDIN.

AFAIK, this pattern has not previously been described.


