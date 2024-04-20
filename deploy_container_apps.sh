# bin/bash

set -e

# Need to exec From Console
# az login

CONTAINER_APP_NAME=my-container-app-v1
RESOURCE_GROUP=tatsukoni-test-v2
CONTAINER_APP_ENVIRONMENT=my-environment-v1
IMAGE=acrtatsukonidemov1.azurecr.io/servicebus-receiver:20240420103927
REVISION_SUFFIX=$(date +%Y%m%d%H%M%S)
REGISTORY_USERNAME=acrtatsukonidemov1
REGISTORY_PASSWORD=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
REGISTORY_SERVER=acrtatsukonidemov1.azurecr.io

az containerapp create \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINER_APP_ENVIRONMENT \
  --image $IMAGE \
  --min-replicas 1 \
  --max-replicas 1 \
  --revision-suffix $REVISION_SUFFIX \
  --registry-username $REGISTORY_USERNAME \
  --registry-password $REGISTORY_PASSWORD \
  --registry-server $REGISTORY_SERVER \
  --ingress external \
  --target-port 80
