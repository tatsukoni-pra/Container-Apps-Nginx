# bin/bash

set -e

for i in {1..5}; do
  echo "チェック回数: $i"
  result=$(az containerapp revision show --revision "my-container-app-v1--20240923233605" --resource-group "tatsukoni-test-v2")
  healthState=$(echo $result | jq -r '.properties.healthState')
  isActive=$(echo $result | jq -r '.properties.active')
  runningState=$(echo $result | jq -r '.properties.runningState')
  if [ "$healthState" = "Healthy" ] && [ "$isActive" = "true" ] && [ "$runningState" = "RunningAtMaxScale" ]; then
    echo "Container Health Check: OK"
    break
  elif [ "$i" -eq 5 ]; then
    echo "Container Health Check: NG"
    exit 1
  else
    echo "Container Health Check: Activating"
    sleep 5
  fi
done
