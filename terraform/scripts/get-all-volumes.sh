#!/bin/sh
set -e

eval "$(jq -r '@sh "INSTANCE_ID=\(.instance_id) AWS_ACCESS_KEY_ID=\(.aws_access_key_id) AWS_SECRET_ACCESS_KEY=\(.aws_secret_access_key) AWS_DEFAULT_REGION=\(.aws_region)"')"

VOLUMES=$(AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r '.Reservations[0].Instances[0].BlockDeviceMappings[] | .Ebs.VolumeId' | tr '\n' ' ' | awk '{$1=$1};1')
jq -n --arg volumes "$VOLUMES" '{"volumes":$volumes}'