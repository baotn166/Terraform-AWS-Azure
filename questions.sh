#!/bin/bash

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
        ((counter++))
    done
}


function main() {
    # Input AWS credentials
    local awsCredentialsEnv=$(inputAwsCredentials)

    enter 1

    # Input Instance id
    local instanceIdEnv=$(inputInstanceId)

    # Input S3 bucket
    local s3Bucket=$(inputS3Bucket)
}

main $@