#!/bin/sh

function inputAwsCredentials() {
    read -p "AWS Access Key Id: " accessKeyId
    # Secret access key should be hidden on screen, using -s (silent)
    read -sp "AWS Secret Access Key: " secretAccessKey
    echo "AWS_ACCESS_KEY_ID=$accessKeyId AWS_SECRET_ACCESS_KEY=$secretAccessKey"
}

function inputInstanceId() {
    read -p "Instance Id: " instanceId
    echo "INSTANCE_ID=$instanceId"
}

function inputAwsRegion() {
    read -p "AWS Region: " region
    echo "AWS_REGION=$region"
}

function inputS3Bucket() {
    read -p "S3 Bucket: " s3Bucket
    echo "S3_BUCKET=$s3Bucket"
}

function enter() {
    local times=$1
    local counter=1
    while [ $counter -le $times ]
    do
        echo -ne '\n'
        counter=$(( $counter + 1 ))
    done
}

function main() {
    # Input AWS credentials
    local awsCredentialsEnv=$(inputAwsCredentials)
    export $awsCredentialsEnv

    enter 1

    # Input Instance id
    local instanceIdEnv=$(inputInstanceId)
    export $instanceIdEnv

    # Input S3 bucket
    # local s3Bucket=$(inputS3Bucket)

    # Input AWS region
    local awsRegionEnv=$(inputAwsRegion)
    export $awsRegionEnv

    eval "echo \"$(cat values-template.tfvars)\" > values.tfvars"

    terraform init terraform
    terraform plan -var-file=values.tfvars terraform
    terraform apply -var-file=values.tfvars -auto-approve terraform
    terraform state rm aws_s3_bucket.s3_bucket
    terraform destroy -var-file=values.tfvars -auto-approve terraform
}

main $@