# bmai - Generate BMA commands from natural language

The `bmai` command helps generate bash-my-aws functions from natural language descriptions using AI. It reads the project's conventions and generates compliant functions that follow the established patterns.

## Prerequisites

- Install and configure [llm](https://github.com/simonw/llm)
  ```bash
  pip install llm
  ```
- Configure an LLM provider (e.g., OpenAI API key)
  ```bash
  llm keys set openai
  ```

## Usage

```bash
source ~/.bash-my-aws/lib/extras/bmai
bmai "list s3 buckets"
```

## Features

- Generates authentic bash-my-aws functions from natural language descriptions
- Follows established conventions and patterns
- Creates functions that integrate with existing BMA commands
- Saves generated functions for review

## Installation

The `bmai` command is included in the extras directory:

```bash
source ~/.bash-my-aws/lib/extras/bmai
```

## Examples

*Note: BMA's `buckets` command already does this.*

```bash
# Generate a command to list S3 buckets
$ bmai "list s3 buckets"
s3-buckets() {
  # List S3 buckets in current region
  #
  #   $ s3-buckets
  #   example-bucket   2019-12-14  NEVER_UPDATED  NO_STACK
  #   another-bucket   2020-03-01  NEVER_UPDATED  NO_STACK

  aws s3api list-buckets \
    --output text \
    --query "
      Buckets[].[
        Name,
        CreationDate,
        join(',', ['NEVER_UPDATED']),
        join(',', ['NO_STACK'])
      ]" |
  columnise
}
```

Generated functions are saved to:
`~/.bash-my-aws/contrib/ai/slop/`

## How It Works

1. Takes a natural language description as input
2. Reads the project's CONVENTIONS.md file
3. Uses AI to generate a compliant function
4. Saves output to a file for review
5. Displays the generated function

The generated functions follow BMA conventions including:
- Standard argument handling
- Integration with skim-stdin
- Consistent output formatting
- Proper error handling
- Clear documentation and examples

Note: The example above shows the author's original response after realizing how simple and elegant the S3 bucket listing function could be while still following all conventions.

