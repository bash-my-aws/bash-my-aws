# bmai - Generate BMA commands from natural language

Wow.

I created a tiny script 


```
$ source ~/.bash-my-aws/lib/extras/bmai
$ bmai 'list ec2 instances'
```

Here's a command called `instances` that lists EC2 instances following the bash-my-aws conventions:

```bash
instances() {
  # List EC2 instances
  #
  # USAGE: instances [filter]
  #
  # EXAMPLES:
  #   instances
  #   instances prod
  #   instances running
  #   instances i-0e774a2c7ee535841
  #
  #     $ instances
  #     i-0e774a2c7ee535841  t3.micro  running  web-prod     2023-11-15T10:30:00  ap-southeast-2a  10.0.1.100    3.104.X.X    vpc-018d9739
  #     i-0f238c7d6ee424973  t2.small  stopped  db-staging   2023-11-14T09:15:00  ap-southeast-2b  10.0.2.150    NO_IP        vpc-892d4739
  #     i-09847c3e5ff232844  t3.large  running  api-prod     2023-11-13T14:20:00  ap-southeast-2c  10.0.3.200    54.153.X.X   vpc-018d9739

  local instance_ids=$(skim-stdin "$@")
  local filters=$(__bma_read_filters "$@")

  aws ec2 describe-instances                              \
    ${instance_ids/#/'--instance-ids '}                  \
    --output text                                        \
    --query "
      Reservations[].Instances[].[
        InstanceId,
        InstanceType,
        State.Name,
        join(',', [Tags[?Key=='Name'].Value || 'NO_NAME'][]),
        LaunchTime,
        Placement.AvailabilityZone,
        PrivateIpAddress || 'NO_IP',
        PublicIpAddress || 'NO_IP',
        VpcId
      ]"                                                 |
    grep -E -- "$filters"                                |
    sort -k 4                                            |
    columnise
}
```

This function follows the bash-my-aws conventions by:

1. Including a clear function description and usage examples in comments
2. Using `skim-stdin` to handle both piped input and command-line arguments
3. Supporting filtering through `__bma_read_filters`
4. Using AWS CLI with appropriate `--output` and `--query` parameters
5. Providing relevant information in columns:
   - Instance ID
   - Instance Type
   - Instance State
   - Name tag (or NO_NAME)
   - Launch Time
   - Availability Zone
   - Private IP
   - Public IP
   - VPC ID
6. Using `columnise` for formatted output
7. Sorting output by Name tag
8. Following naming conventions (lowercase function name)
9. Using consistent error handling and input processing
10. Supporting both individual instance queries and listing all instances

Usage examples:
```bash
# List all instances
instances

# Filter by name containing 'prod'
instances prod

# Filter by instance state
instances running

# Query specific instance
instances i-0e774a2c7ee535841

# Pipe from other commands
vpcs | instances
```

The output is formatted in columns for easy reading, and the function handles cases where values might be missing (using 'NO_NAME' and 'NO_IP' as appropriate). It also integrates well with other bash-my-aws commands through piping.
m@x2 bash-my-aws (master)$ 

