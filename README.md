## Task 4: Jenkins Installation and Configuration
### Install kubectl

```
choco install kubernetes-cli -y
```

### Install & start minikube
You must install & run Docker before it
```
choco install minikube -y
minikube start --driver=docker
```

You can open Kubernetes Dashboard for displaying the cluster management graphical interface
```
minikube dashboard
```

### Install helm

```
choco install kubernetes-helm -y
```

### Add the Bitnami Helm chart repository
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### Deploys an Nginx server with default settings

```
helm install my-nginx bitnami/nginx
```
You can verify the deployment:
```
kubectl get all
```
To get a working URL:
```
minikube service my-nginx --url
```
To run Kubernetes Dashboard
```
minikube dashboard
```
Uninstall the chart:
```
helm uninstall my-nginx
```

## Prepare the Cluster

Minikube has a built-in provisioner for PV/PVC by default.
To check the functionality of Dynamic Provisioning:
```
kubectl get storageclass
```

## Jenkins Installation 

Create namespace for Jenkins, add Helm-repository and install Jenkins:
```
kubectl create namespace jenkins
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins jenkins/jenkins --namespace jenkins
```

for checking:
```
kubectl get pods -n jenkins
```

recieve password and addres for Jenkins Dashboard in the web browser:
```
get secret jenkins -n jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
minikube service jenkins --namespace jenkins --url
```

### Persistent Jenkins Configuration

To verify that Jenkins uses persistent storage:

1. Created a freestyle project `HelloWorld` and ran a build.
2. Deleted the Jenkins pod:

   ```
   kubectl delete pod jenkins-0 -n jenkins
   ```
After pod restart, Jenkins retained the job and build history.

Jenkins was deployed with a PersistentVolumeClaim named jenkins, automatically provisioned by the Helm chart. This ensures that Jenkins configuration survives pod restarts.

## Authentication and Security

In web-interface:  

 - Manage Jenkins -> Manage Users -> Create User
 - Manage Jenkins -> Plugins -> Available  
install "Matrix Authorization Strategy"
 - Manage Jenkins -> Security  
in Authorization choose "Matrix-based security"  
for each user choose permissions  

## JCasC to describe job in Jenkins

Update dependencies:
```
helm dependency update .
```

Install jenkins with job:
```
helm install jenkins ./jenkins-chart
```

Create connection for web-interface:
```
kubectl port-forward svc/jenkins 8080:8080
```

For checking pods:
```
kubectl get pods -l app.kubernetes.io/name=jenkins
```
