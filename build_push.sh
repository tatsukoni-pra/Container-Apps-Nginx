# bin/bash

set -e

# Need to exec From Console
# az login
# az acr login --name acrtatsukonidemov1

AZURE_CONTAINER_REGISTRY=acrtatsukonidemov1.azurecr.io
REPOSITORY_NAME=servicebus-receiver
CONTAINER_IMAGE_TAG=$(date +%Y%m%d%H%M%S)

docker build --platform linux/amd64 -t $AZURE_CONTAINER_REGISTRY/$REPOSITORY_NAME:$CONTAINER_IMAGE_TAG .
docker push $AZURE_CONTAINER_REGISTRY/$REPOSITORY_NAME:$CONTAINER_IMAGE_TAG
