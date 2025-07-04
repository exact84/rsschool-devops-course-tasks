##Task 4: Jenkins Installation and Configuration
###Install kubectl .

```
choco install kubernetes-cli -y
```

###Install & start minikube.
You must install & run Docker before it
```
choco install minikube -y
minikube start --driver=docker
```

You can open Kubernetes Dashboard for displaying the cluster management graphical interface
```
minikube dashboard
```

###Install helm .

```
choco install kubernetes-helm -y
```

##Add the Bitnami Helm chart repository
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

##Deploys an Nginx server with default settings

```
helm install my-nginx bitnami/nginx
```

