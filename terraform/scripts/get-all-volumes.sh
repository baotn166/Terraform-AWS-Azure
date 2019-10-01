#!/bin/bash
set -e

VOLUMES=$(aws ec2 describe-instances --instance-ids i-0a373f77364f1731a | jq -r '.Reservations[0].Instances[0].BlockDeviceMappings[] | .Ebs.VolumeId')
jq -n --arg volumes "$VOLUMES" '{"volumes":$volumes}'