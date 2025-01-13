# bmai - Generate BMA commands from natural language

The `bmai` command helps generate bash-my-aws functions from natural language descriptions using AI. It reads the project's conventions and generates compliant functions that follow the established patterns.

## Usage

```bash
source ~/.bash-my-aws/lib/extras/bmai
bmai 'list ec2 instances'
```

## Features

- Generates authentic bash-my-aws functions from natural language descriptions
- Follows established conventions and patterns
- Creates functions that integrate with existing BMA commands
- Outputs to a temporary file for review before use

## Installation

The `bmai` command is included in the extras directory. To use it:

1. Ensure you have the `llm` command line tool installed
2. Source the bmai script:
   ```bash
   source ~/.bash-my-aws/lib/extras/bmai
   ```

## Examples

```bash
# Generate a command to list EC2 instances
bmai 'list ec2 instances'

# Generate a command to show VPC endpoints
bmai 'show vpc endpoints'

# Generate a command to delete old snapshots
bmai 'delete snapshots older than 30 days'
```

Generated functions will be saved to:
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

