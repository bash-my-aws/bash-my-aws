# Do some minimal hoop-jumping so this repo can be loaded as a ZSH plugin

# All we need to do is figure out where we were cloned and source
# the cloudformation-functions file
source $(dirname $0)/cloudformation-functions
