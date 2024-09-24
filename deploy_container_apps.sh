# bin/bash

set -e

# Need to exec From Console
# az login

REVISION_SUFFIX=$(date +%Y%m%d%H%M%S)
SERVICEBUS_NAME=servicebus-tatsukoni-test-v2
CONTAINER_IMAGE_TAG=20240923233507

sed -e "s/<revisionSuffix>/$REVISION_SUFFIX/g" \
    -e "s/<servicebus-name>/$SERVICEBUS_NAME/g" \
    -e "s/<container-image-tag>/$CONTAINER_IMAGE_TAG/g" \
    template-dapr.tpl.yml > template.yml

az containerapp create \
  --name my-container-app-v1 \
  --resource-group tatsukoni-test-v2 \
  --environment my-environment-v1 \
  --yaml template.yml
