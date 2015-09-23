services="
  asg
  cloudformation
  ec2
"

for service in ${services}; do
  source $(dirname ${BASH_SOURCE[0]})/${service}.inc
done

# vim: ft=sh
