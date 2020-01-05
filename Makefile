test: run_tests

run_tests:
	'./test/shared-spec.sh'
	'./test/stack-spec.sh'

bash_completion:
	'./test/generate_bash_completion' > './bash_completion.sh'
