## dev guidelines

star fork
 545   52   pact
  46   19   bash-my-aws
  43   12   credulous

* alphabetise

? won't BMA_OUTPUT break some things if not text?
? what do we do about piping to ssh (user arg) - can we use both?

what happens when we pipe nothing through?
- instances | grep foobar | instance_types

instances_tagged()
- kept original names (instance_with_tag) for backward compatibility
- happy to consider breaking change

instance_volumes()
- left it out for now till we sort out output

instance_types()
- query+detail? or just detail?
