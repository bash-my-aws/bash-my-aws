bash-my-aws style guide
=======================

* Always quote "$variables"
* Only use parentheses around variables when not surrounded with whitespace (better way to phrase this?)
* use ``$(date)`` rather than "``date``"
* use `[[` and `]]` rather than `[`, `]`, or `test`

* show errors with `__bma_error()`
* show usage options with `__bma_usage()`
* parse inputs with `__bma_read_inputs()`
* make sure commands support `--json` and `--text` output options

* regenerate and test the bash_completion script after adding new functions
