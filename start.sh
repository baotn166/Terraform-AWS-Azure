#!/bin/bash
set -e

IMAGE_TAG="latest"
CONTAINER_NAME="automation-tool"
IMAGE_NAME="alpine_tool"

function startAlpineTool() {
    echo "Starting container $CONTAINER_NAME"
    docker build -t $IMAGE_NAME:$IMAGE_TAG .
    docker run --name $CONTAINER_NAME -it -d $IMAGE_NAME:$IMAGE_TAG
}

function stopAlpineTool() {
    echo "Stopping container $CONTAINER_NAME"
    docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
}

function startAutomation() {
    echo "Running automation"
    docker exec -it $CONTAINER_NAME "run.sh"
}

function main() {
    stopAlpineTool || true
    startAlpineTool
    startAutomation
}

main $@