## ContainerApps 起動スクリプト内で失敗した場合の挙動

### 実行の状態
- `アクティブ化失敗` となる
- 「最初のレプリカのプロビジョニングに失敗しました。」という意味
- https://learn.microsoft.com/ja-jp/azure/container-apps/revisions#running-status

### 状態の詳細
- `Deployment Progress Deadline Exceeded. 0/2 replicas ready.`となる
- 新しいリビジョンのプロビジョニングに 10 分以上かかったために発生
- https://learn.microsoft.com/ja-jp/azure/container-apps/troubleshooting?tabs=bash#scenarios

### ContainerAppSystemLogs_CL

- 起動 ~ 停止 を永遠に繰り返す

```
2024/9/23 13:12:20.055
PullingImage
Pulling image 'acrtatsukonidemov1.azurecr.io/nginx:20240923170749'

2024/9/23 13:12:20.055
PulledImage
Successfully pulled image 'acrtatsukonidemov1.azurecr.io/nginx:20240923170749' in 0.018694s

2024/9/23 13:12:20.055
ContainerCreated
Created container 'nginx'

2024/9/23 13:12:20.055
ContainerStarted
Started container 'nginx'

2024/9/23 13:12:20.055
ContainerTerminated
Container 'nginx' was terminated with exit code '1' and reason 'ProcessExited'
```

## ContainerApps の状態がアクティブかどうか確認する方法

```
healthState=$(az containerapp revision show --revision "my-container-app-v1--20240923233605" --resource-group "tatsukoni-test-v2" --query "properties.healthState")

isActive=$(az containerapp revision show --revision "my-container-app-v1--20240923233605" --resource-group "tatsukoni-test-v2" --query "properties.active")

healthState == "Healthy" && isActive == false
```

正常時
```
❯❯❯ az containerapp revision show --revision "my-container-app-v1--20240923231223" --resource-group "tatsukoni-test-v2"
{
  "name": "my-container-app-v1--20240923231223",
  "properties": {
    "active": true,
    "healthState": "Healthy",
    "provisioningState": "Provisioned",
    "replicas": 2,
    "runningState": "RunningAtMaxScale",
    ...
  }
}
```

アクティブ化中
```
❯❯❯ az containerapp revision show --revision "my-container-app-v1--20240923233605" --resource-group "tatsukoni-test-v2"
{
  "name": "my-container-app-v1--20240923233605",
  "properties": {
    "active": true,
    "healthState": "None",
    "provisioningState": "Provisioned",
    "replicas": 2,
    "runningState": "Activating",
  }
}
```

アクティブ化失敗
```
❯❯❯ az containerapp revision show --revision "my-container-app-v1--20240923233605" --resource-group "tatsukoni-test-v2"
{
  "name": "my-container-app-v1--20240923233605",
  "properties": {
    "active": true,
    "healthState": "Unhealthy",
    "provisioningState": "Provisioned",
    "replicas": 2,
    "runningState": "ActivationFailed",
    "runningStateDetails": "Deployment Progress Deadline Exceeded. 0/2 replicas ready.",
  }
}
```

非アクティブ状態
```
❯❯❯ az containerapp revision show --revision "my-container-app-v1--20240923233605" --resource-group "tatsukoni-test-v2"
{
  "name": "my-container-app-v1--20240923233605",
  "properties": {
    "active": false,
    "healthState": "Healthy",
    "lastActiveTime": "2024-09-23T15:24:08+00:00",
    "provisioningState": "Provisioned",
    "replicas": 0,
    "runningState": "Stopped",
  }
}
```
