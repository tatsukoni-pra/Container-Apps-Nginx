# bin/bash

set -e

# Need to exec From Console
# az login

ENVIRONMENT_NAME=my-environment-v1
RESOURCE_GROUP_NAME=tatsukoni-test-v2

# ContainerApps環境 > 設定 > Daprコンポーネント にコンポーネントが作成される
# https://learn.microsoft.com/ja-jp/azure/container-apps/dapr-overview?tabs=bicep1%2Cyaml#component-schema
# https://learn.microsoft.com/ja-jp/azure/container-apps/dapr-components?tabs=yaml
az containerapp env dapr-component set \
  --name $ENVIRONMENT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --dapr-component-name azurekeyvault \
  --yaml dapr-azurekeyvault.yaml
