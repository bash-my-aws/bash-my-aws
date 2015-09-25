# parameter.inc
#
# Deal with stdin and arguments.

__bma_read_inputs() {
  echo "$(__bma_read_stdin) $@" |
    sed -E 's/\ +$//'           |
    sed -E 's/^\ +//'
}

__bma_read_stdin() {
  [[ -t 0 ]] ||
    cat /dev/stdin       |
      awk '{ print $1 }' |
      tr '\n' ' '        |
      sed 's/\ $//'
}

__bma_read_resources() {
  __bma_arg_types $@ |
    grep '^r'        |
    cut -d: -f2-
}

__bma_read_switches() {
  result="$(
    __bma_arg_types "$@"    |
      grep '^s:'            |
      cut -d: -f2-          |
      sort
  )"
  __bma_expand_switches "${result}"
}

__bma_arg_types() {
  local switched=false

  for arg in $(echo $@); do
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
  # this function is for expanding or rewriting switches.
  echo "$@"                             |
    sed -E 's/^--json/--output json/'   |
    sed -E 's/^--text/--output text/'   |
    sed -E 's/^-f/--filters/'           |
    sed -E 's/^-q/--query/'
}

# vim: ft=sh
