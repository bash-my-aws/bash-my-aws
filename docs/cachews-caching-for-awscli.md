# Cachews - Caching for AWSCLI

cachews is a zero-config caching proxy for awscli.

Reducing request time by around 90% may also reduce:

- cycle time when constructing commands or scripts that use awscli
- your resistance to running a query across 500 accounts
- how often you put the kettle on

![Cache of Cachews](images/cachews.png)

It supports the following arguments (and ignores the rest):

  `--query`   : JMESPath querys as found in awscli (and azcli)  
  `--output`  : `json` or `text` (tab separated values)

## Installation

cachews comes included with bash-my-aws which is installed as follows:

1. Clone the repo

```Shell
git clone https://github.com/bash-my-aws/bash-my-aws.git ${BMA_HOME:-$HOME/.bash-my-aws}
```

2.  Put the following in your shell's startup file:

```Shell
export PATH="$PATH:${BMA_HOME:-$HOME/.bash-my-aws}/bin"
source ${BMA_HOME:-$HOME/.bash-my-aws}/aliases

# For ZSH users, uncomment the following two lines:
# autoload -U +X compinit && compinit
# autoload -U +X bashcompinit && bashcompinit

source ${BMA_HOME:-$HOME/.bash-my-aws}/bash_completion.sh
```

3. [Optional] Set CACHEWS_DIR environment variable.


## Usage

Choose from two commands two suit your needs:

- `cachews`: A drop in replacement for `aws` command
- `cachews-replace`: Runs any command, replacing `aws` with `cachews` executable

As a bonus, you can set `BMA_AWSCLI=cashews` to enable for all bash-my-aws commands.

See below for real world examples.

### `cachews` - Replace `aws` command with `cachews`

The simplest use case is to substitute `aws` for `cachews` in your command.

Start a fresh cachedir for this demo:

```shell
$ export CACHEWS_DIR="$(mktemp -d)"
```

AWS command takes ~1s:

```shell
$ time aws ec2 describe-instances | wc -l
844

real	0m1.113s
user	0m0.823s
sys	    0m0.076s
```

cachews takes ~1s but caches the response:

```shell
$ time cachews ec2 describe-instances | wc -l
844

real	0m1.147s
user	0m0.861s
sys	    0m0.088s
```

cachews takes ~0.08 seconds the second time:

```shell
$ time cachews ec2 describe-instances | wc -l
844

real	0m0.081s
user	0m0.061s
sys	    0m0.023s
```

### cachews-replace - avoids need to change code

This could be a script with AWSCLI calls or even this crazy example.

```shell
$ time cachews-replace aws ec2 describe-instances | wc -l
844

real	0m0.083s
user	0m0.065s
sys	0m0.020s
```

### bash-my-aws commands can use `$BMA_AWSCLI` env var

The `bma` command exports a function called `aws` that calls the
command in BMA_AWSCLI=cachews if one is set.

```shell
$ time bma instances | wc -l
4

real	0m1.200s
user	0m0.834s
sys	  0m0.098s
```

```shell
$ time BMA_AWSCLI=cachews bma instances | wc -l
4

real	0m0.099s
user	0m0.079s
sys	  0m0.026s
```

bash-my-aws added `$BMA_AWSCLI` support back in 2020 to assist testing breaking
changes in aws-cli-v2. Almost four years later when I wrote cachews it was a
nice surprise to rediscover it.

```
commit 17376e63222033fef2a1005be6bccb0123263629
Author: Mike Bailey <mike@bailey.net.au>
Date:   Sun Mar 8 12:25:00 2020 +1100

    Set $BMA_AWSCLI to specify which awscli to use
    
    Added while testing breaking changes in aws-cli-v2
    
    Also useful for testing with
    [localstack](https://github.com/localstack/localstack)
    
      e.g. `$ BMA_AWSCLI=awslocal stacks`
    
    Also, print AWSCLI version when BMA_DEBUG=true
```
