# bash-my-aws development guide.

There are three distinct classes of functions types within `bash-my-aws`; *query*, *detail*, and *action* functions.

Query functions are responsible for requesting AWS return a list of resources by their unique identifier. That would mean that when querying EC2 instances, it should return a list of instance-ids. If we were to query CloudFormation, then stacks are what would be returned.

Detail functions should provide you an output of one or more attributes.

Action functions should perform an action against a resource. An action for an EC2 instance may be something like *terminate* or *associate_eip*.

There are some great things about `awscli` which I would hate to loose.

* It is easy to look at the code and learn how `awscli` works.
* Simple tasks have simple commands.
* It's really easy to extend.

However, that only goes as far as making me excited about working on the project. I want to make it more consistent and more intuitive.

`bash-my-aws` should work *with* `awscli`, not against it. It should behave more like a wrapper and less like a separate tool. When you parse in default `awscli` [arguments](http://docs.aws.amazon.com/cli/latest/reference/#options) options, you should expect them to work. Likewise, if you set [environment variables](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html), they should always work too.

stdin should always be supported. You should be able to pipe one function into the next with ease. If an action function cannot be piped the output of a query function and have it work, without manipulation though other tools, then something is wrong.

## Namespacing

The namespacing of the function names is a little bit muddled. The EC2 stuff is namespaced under the name of the resource. The CloudFormation stuff is namespaced under an abbreviated AWS service name which just so happens to be more appropriate for the CloudFront service. As there are only currently two services, it is impossible to know which pattern to is the correct one to follow.

In my opinion, neither of the current patterns are perfect. I have two propositions:

1. We prefix all functions with `bma_` so that if Amazon in the future announce a service named something like "Simple Excellent Dodad", `sed` will continue to work.

2. We rename the CloudFormation functions to `bma_stack`. I believe that `awscli`  made a mistake to use the AWS service name in their namespace. An edge case exists when a service is responsible for more than one type of resource. For example, EC2 is responsible for both instances and security groups. To accommodate that fact, your command could be something like `bma_ec2_instance_create` where other services which only create a single type of resource would be namespaced `bma_cfn_create`. Also you are not creating the service, you're creating a resource. People extending the app would be inclined to name their function 'bma_cfn_stack_create'. I for one like short function names.

## Resources

This is a partial list of resources, with possible alternative names in brackets.

- asg               (autoscaling_group)
- bucket
- elb               (load_balancer)
- instance
- instance_type
- rds               (relational_database)
- dynamodb          (relational_database)
- sg                (security_group)
- stack             (cloudformation_stack)


## Query Functions

Query functions are always namespaced under the plural of the resource.

### Default Query

TODO: lets talk about the details.

Some example usage of this function would be:

    $ <resources>
    resource_id1
    resource_id2
    resource_id3


## Detail Functions

Detail functions are always namespaced under the singular of the resource.

TODO: lets talk about the details.

Some example usage of this function would be:

    $ <resource> <resource_id>
    attribute1: value1
    attribute2: value2

Some example responses:

    $ instance_security_groups i-abcd1234
    sg-00000001 i-abcd1234
    sg-00000002 i-abcd1234
    sg-00000003 i-abcd1234
    sg-00000004 i-abcd1234

    $ security_group_rules
    TODO: I'm not sure yet how to present a security group rule.

    $ instance_type i-abcd1234
    c3.large i-abcd1234

    $ instance_type_memory c3.large
    3.75 c3.large



## Action Functions

Action functions are always namespaced under the singular of the resource and are suffixed with the action they are responsible for undertaking.

TODO: lets talk about the details.

Some example usage of this function would be:

    $ <resource>_<action> <resource_id>


