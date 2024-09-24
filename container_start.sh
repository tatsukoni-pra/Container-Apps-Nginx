#!/bin/bash

set -e

rm -f .env
touch .env

# .envファイル作成
if [ ! -e "env.json" ]; then
  echo "Error: env-definition-dev.json が存在しません" >&2
  exit 1
fi
cat env.json | jq -c '.secret_env[]' | while read -r secret_env; do
  secret_name=$(echo $secret_env | jq -r '.name')
  secret_key_vault_name=$(echo $secret_env | jq -r '.secretref')
  secret_version=$(echo $secret_env | jq -r '.version')
  secret_value=$(curl -s "http://localhost:${DAPR_HTTP_PORT}/v1.0/secrets/azurekeyvault/${secret_key_vault_name}?metadata.version_id=${secret_version}" | jq -r ".\"${secret_key_vault_name}\"")
  if [ "$secret_value" = "null" ] || [ "$secret_value" = "" ]; then
      echo "Error: Failed to retrieve secret ${secret_name}" >&2
      exit 1
  fi
  echo "${secret_name}=${secret_value}" >> .env
done

cat env.json | jq -c '.env[]' | while read -r env; do
  env_name=$(echo $env | jq -r '.name')
  env_value=$(echo $env | jq -r '.value')
  echo "${env_name}=${env_value}" >> .env
done

# Nginx起動
nginx -g "daemon off;"
