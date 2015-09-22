#!/bin/bash
# legacy - doesn't fit new pipeable architecture

instances_without_tag() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME tag_key [tag_value]"; return 1; fi
  local tag_key=$1
  local tag_value=$2
  if [ -z "$tag_value" ]; then
    query="Reservations[].Instances[?contains(Tags[].Key[], \`$tag_key\`) != \`true\`][].${INSTANCE_OUTPUT}" \

    local query="
      Reservations[].Instances[?contains(
        Tags[].Key[], \`$tag_key\`
      ) != \`true\`][
        {
          \"InstanceId\": InstanceId,
          \"Name\":       [Tags[?Key==\`Name\`].Value][0][0]
        }
      ][]
    "
  else
    #query="Reservations[].Instances[?contains(Tags[?Key==\`$tag_key\`].Value[], \`$tag_value\`) != \`true\`][].${INSTANCE_OUTPUT}" \
    local query="blah"
  fi

  instances --query ${query}
}

instances_with_tag() {
  # type: query
  # returns instance id's and the name tag.
  # TODO: write usage.

  local inputs=$(__bma_read_inputs $@)
  local tag_name=$(__bma_read_resources ${inputs} | sed '1q;d')
  local tag_value=$(__bma_read_resources ${inputs} | sed '2q;d')
  local filters="Name=tag:${tag_name},Values=${tag_value:-"*"}"
  instances $(__bma_read_switches ${inputs}) --filters ${filters}
}

