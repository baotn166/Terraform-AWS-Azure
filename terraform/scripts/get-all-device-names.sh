#!/bin/bash
set -e

eval "$(jq -r '@sh "INSTANCE_ID=\(.instance_id)"')"

DEVICES=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r '.Reservations[0].Instances[0].BlockDeviceMappings[] | .DeviceName' | tr '\n' ' ' | awk '{$1=$1};1')
jq -n --arg devices "$DEVICES" '{"devices":$devices}'