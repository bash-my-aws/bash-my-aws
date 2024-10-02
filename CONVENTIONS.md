# Coding Conventions

This document outlines the coding conventions used in our project, particularly for bash scripts and AWS CLI commands.

## Bash Scripts

### Function Naming
- Use lowercase with hyphens for function names (e.g., `vpc-subnets`, `vpc-route-tables`).
- Function names should be descriptive of their purpose.

### Comments
- Use `#` for single-line comments.
- Include a brief description of the function's purpose immediately after the function name.
- For complex functions, add usage examples in the comments.

### AWS CLI Commands
- Use `aws` followed by the service name (e.g., `aws ec2`, `aws rds`).
- Prefer `--output text` for consistent and easily parseable output.
- Use `--query` with JMESPath expressions for filtering and formatting output.

### Output Formatting
- Use `columnise` (a custom function) to format output into columns.
- Sort output when appropriate (e.g., `sort -k 5`).

### Error Handling
- Check for required arguments using `[[ -z "$vpc_ids" ]] && __bma_usage "vpc-id [vpc-id]" && return 1`.

### Looping
- Use `for` loops to iterate over multiple VPC IDs or other resources.

### Variable Naming
- Use lowercase for local variables (e.g., `local vpc_ids`, `local filters`).
- Use uppercase for environment variables or constants (e.g., `$AWS_DEFAULT_REGION`).

### Input Handling
- Use `skim-stdin` (a custom function) to handle both piped input and arguments.

## AWS Resource Naming
- Use the format `resource-type-action` for function names that interact with specific AWS resources (e.g., `vpc-igw`, `vpc-nat-gateways`).

## Output Conventions
- For listing functions, output should typically include resource IDs and names.
- Include 'NO_NAME' for resources without a Name tag.

## Security Considerations
- Be cautious with functions that perform destructive actions (e.g., `vpc-default-delete`).
- Include safety checks before performing destructive actions.

These conventions are derived from the observed patterns in the lib/vpc-functions file. They should be followed when contributing new functions or modifying existing ones to maintain consistency across the project.
