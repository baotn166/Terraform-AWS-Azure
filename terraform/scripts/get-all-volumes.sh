#!/bin/bash
set -e

eval "$(jq -r '@sh "INSTANCE_ID=\(.instance_id)"')"

VOLUMES=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r '.Reservations[0].Instances[0].BlockDeviceMappings[] | .Ebs.VolumeId' | tr '\n' ' ' | awk '{$1=$1};1')
jq -n --arg volumes "$VOLUMES" '{"volumes":$volumes}'