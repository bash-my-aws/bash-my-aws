#!/bin/bash

bma stack-create nagios cloudformation/ec2.yml
bma stack-create postgres01 cloudformation/ec2.yml
bma stack-create postgres02 cloudformation/ec2.yml
bma stack-create prometheus-web cloudformation/ec2.yml
