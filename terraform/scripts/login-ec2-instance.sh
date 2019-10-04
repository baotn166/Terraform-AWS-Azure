set -e

export INSTANCE_ID=$2
export REGION=$3
export public_ip=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --query Reservations[*].Instances[*].PublicIpAddress --region $REGION --output text`
echo $public_ip
chmod 400 ec2.pem
scp -o StrictHostKeyChecking=no -i ec2.pem terraform/scripts/mount-volume.sh $1@$public_ip:~/
ssh -o StrictHostKeyChecking=no -i ec2.pem $1@$public_ip "chmod +x ./mount-volume.sh && ./mount-volume.sh $4 $5 $6 $7 \"$8\""
