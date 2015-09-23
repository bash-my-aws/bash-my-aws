# parameter.inc
#
# Deal with stdin and arguments.

__bma_read_inputs() {
  # in:  text
  # out: base64
  echo "$(__bma_read_stdin | base64 -D) $@" |
    sed -E 's/\ +$//'                       |
    sed -E 's/^\ +//'                       |
    base64
}

__bma_read_stdin() {
  # in:  text
  # out: base64
  [[ -t 0 ]] ||
    cat /dev/stdin       |
      awk '{ print $1 }' |
      tr '\n' ' '        |
      sed 's/\ $//'      |
      base64
}

__bma_read_resources() {
  # in:  base64
  # out: text
  __bma_arg_types $@ |
    grep '^r'        |
    cut -d: -f2-
}

__bma_read_switches() {
  # in:  base64
  # out: text
  result=$(
    __bma_arg_types "$@"    |
      grep '^s:'            |
      cut -d: -f2-          |
      sort                  |
      base64
  )
  __bma_expand_switches ${result}
}

__bma_arg_types() {
  # in:  base64
  # out: text
  local switched=false

  for arg in $(echo $@ | base64 -D); do
    if [[ "$arg" =~ ^-- ]]; then
      $switched && echo
      switched=true
      echo -n "s:$arg"
      continue
    fi

    if $switched; then
      echo -n " $arg"
      continue
    fi

    echo "r:$arg"
  done
  echo
}

__bma_expand_switches() {
  # in:  base64
  # out: text

  # this function is for expanding or rewriting switches.
  echo $@ | base64 -D                   |
    sed -E 's/^--json/--output json/'   |
    sed -E 's/^--text/--output text/'   |
    sed -E 's/^-f/--filters/'           |
    sed -E 's/^-q/--query/'
}

# vim: ft=sh
