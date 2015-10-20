cf_asg_instance_ssh() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack [user]"; return 1; fi
  local stack="$(basename $1 .json)"

  # local user=$2
  # local instance_id="$(cf_asg_instances $stack | head -1 | cut -f 3)"
  # instance_ssh $instance_id $user # This requires that instance-functions have been loaded
                                    # I'll introduce it shortly as default
                                    # To use in the meantime uncomment this and comment
                                    # out the next three lines

  local user=${2:-${AWS_DEFAULT_USER:-$USER}}
  local instance_ip="$(cf_asg_instances $stack | head -1 | cut -f 1)"
  ssh ${user}@${instance_ip}
}
