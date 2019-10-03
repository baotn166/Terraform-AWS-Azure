set -e

export INSTANCE_ID=$1
export REGION=$2
export public_ip=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --query Reservations[*].Instances[*].PublicIpAddress --region $REGION --output text`
echo $public_ip
scp -o StrictHostKeyChecking=no -i ~/ec2.pem terraform/scripts/mount-volume.sh ec2-user@$public_ip:~/
ssh -o StrictHostKeyChecking=no -i ~/ec2.pem ec2-user@$public_ip "chmod +x ./mount-volume.sh && ./mount-volume.sh" $3 $4 $5 $6 $7
