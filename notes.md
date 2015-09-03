## dev guidelines

star fork
 545   52   pact
  46   19   bash-my-aws
  43   12   credulous


TODO
instance_stack() use --query
instance_type()  use --query
instance_types() use --query # remove

* alphabetise

? what do we do about piping to ssh (user arg) - can we use both?

BMA_OUTPUT remove?

what happens when we pipe nothing through?
- instances | grep foobar | instance_types

instances_tagged()
- kept original names (instance_with_tag) for backward compatibility
- happy to consider breaking change

instance_volumes()
- left it out for now till we sort out output


Test
1. terminal
1. no terminal
1. arguments
1. no arguments
1. STDIN single line, single field 
1. STDIN single line, multiple fields
1. STDIN mutiple lines, single field
1. STDIN mutiple lines, multiple fields
