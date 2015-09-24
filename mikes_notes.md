mike's notes
============

should pipe put everything on same line?


why lib/?

## parameter.inc
- why base64?
- comments on functions (what is __bma_arg_types() for?)


## cloudformation.inc
- stack.inc?
- stack(s)
- do we want to simplify stack listing command?
- hyphen or underscore?


## ec2.inc 
- instances()?
- instance() I don't know which ones are running
- call it instance.inc?

# rather have all on one line - maybe volume first?
$ instance | grep bamboo  | instance-volumes
i-4d26f692
VOLUMES vol-52b1ac99
VOLUMES vol-95b1ac5e
VOLUMES vol-51b1ac9a


$ instance --json
Version DEBUG
Usage:  base64 [-dhvD] [-b num] [-i in_file] [-o out_file]
  -h, --help     display this message
  -v, --version  display version info
  -d, --debug    enables additional output to stderr
  -D, --decode   decodes input
  -b, --break    break encoded string into num character lines
  -i, --input    input file (default: "-" for stdin)
  -o, --output   output file (default: "-" for stdout)
[
    {
        "InstanceId": "i-4d26f692",
        "Name": "cp-bamboo-docker-agent"
    },


## asg.inc

  if __bma_read_switches ${inputs} | grep ^--debug > /dev/null; then
    BMA_DEBUG=true
  else
    BMA_DEBUG=false
  fi
