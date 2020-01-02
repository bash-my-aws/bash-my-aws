## Suggested stack/template/param file naming conventions

bash-my-aws can take a lot of the effort out of creating and updating
CloudFormation (CFN) stacks. Tab completion on remote stack names and
even local file names is provided.

Additionally, the create/update/diff commands can make life much easier
if you follow some simple file naming conventions.

*These are completely optional.*


    stack   : token-env
    template: token.yml
    params  : token-params-env.json or params/token-params-env.json

Where:

    token : describes the resources (mywebsite, vpc, bastion, etc)
    env   : environment descriptor (dev, test, prod, etc)

Following these (entirely optional) conventions means bash-my-aws can
infer template & params file from stack name. For example:

    $ stack-create mywebsite-test

is equivalent (if files present) to:

    $ stack-create mywebsite-test mywebsite.yml mywebsite-params-test.json

you could even achieve the same result with:

    $ stack-create mywebsite-params-test.json


Other benefits include:

* ease in locating stack for template (and vice versa) based on name
* template and params files are listed together on filesystem
* stack name env suffixes protect against accidents (wrong account error)
* supports prodlike non-prod environments through using same template

And don't forget, these naming conventions are completely optional.
