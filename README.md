# Application Deployment via Jenkins Pipeline

## Project Structure

- jenkins-kubectl/
  - Dockerfile
- flask-app/
  - .helmignore
  - Dockerfile
  - Jenkinsfile
  - main.py
  - test_app.py
  - Chart.yaml
  - values.yaml
  - sonarqube.yaml
  - sonar-project.properties
  - requirements.txt
  - templates/
     - ... (deployment.yaml, service.yaml, etc.)

## Jenkins pipeline (Jenkinsfile)

The pipeline is defined in `flask-app/Jenkinsfile` and includes the following stages:

- **Checkout** — Clone the repository
- **Setup RBAC** — Configure roles for Kaniko and Helm
- **Build and Push Docker Image with Kaniko** — Build and publish Docker image to Docker Hub
- **Test** — Run unit tests with pytest
- **SonarQube Analysis** — Static code analysis and Quality Gate
- **Deploy to Kubernetes** — Deploy the app using Helm
- **Smoke Test** — Verify app availability inside the cluster via curl
- **Notifications** — Email notification on pipeline result

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Helm](https://helm.sh/)
- [Docker](https://www.docker.com/)
- [Jenkins](https://www.jenkins.io/) (deployed in Minikube)
- [SonarQube](https://www.sonarqube.org/) (deployed in Minikube)
- Docker Hub account

## Jenkins Agent Image

Build a custom Jenkins agent image with kubectl, helm, and python
and push it to Docker Hub:
```
cd jenkins-kubectl
docker build -t exact84/jenkins-agent-kubectl:latest .
docker login
docker push exact84/jenkins-agent-kubectl
```

## Jenkins Installation/Upgrade

```
helm repo add jenkins https://charts.jenkins.io
helm repo update
kubectl create namespace jenkins

helm install jenkins jenkins/jenkins -n jenkins \
  --set agent.image.registry=docker.io \
  --set agent.image.repository=exact84/jenkins-agent-kubectl \
  --set agent.image.tag=latest \
  --set controller.image.registry=docker.io \
  --set controller.image.repository=jenkins/jenkins \
  --set controller.image.tag=v2 \
  --set controller.image.pullPolicy=Always \
  --set controller.serviceType=ClusterIP \
  --set controller.admin.username=admin \
  --set controller.admin.password=admin123 \
  --set controller.disableCsrfProtection=true \
  --set controller.resources.requests.cpu="100m" \
  --set controller.resources.requests.memory="512Mi"
```

Check Jenkins pods:
```
kubectl get pods -n jenkins
```

## Jenkins Plugins

Install and configure in Jenkins:
- Git plugin
- Kubernetes plugin
- SonarQube Scanner Plugin
- Email Extension Plugin

## RBAC Setup

Apply RBAC for Kaniko and Jenkins in namespace `jenkins`:
```
kubectl apply -f flask-app/rbac-access.yaml
```

## Docker Registry Secret

Create a Docker Hub secret for Jenkins:
```
kubectl create secret generic docker-config --from-file=.dockerconfigjson="$HOME/.docker/config.json" --type=kubernetes.io/dockerconfigjson -n jenkins
```
Set the secret ID as `docker-config` in Jenkins.

## SonarQube Setup

Deploy SonarQube:
```
   kubectl apply -f flask-app/sonarqube.yaml
   kubectl get pods -n sonarqube
   kubectl port-forward -n sonarqube svc/sonarqube 9000:9000
```

 Create a project in SonarQube (`flask-app-exact`), generate a token, and add it to Jenkins credentials.

## Pipeline Details

- **Build and Push:** Kaniko builds the image and pushes to Docker Hub with tag `${BUILD_NUMBER}`.
- **Test:** Runs `pytest` on all tests in `flask-app/`.
- **SonarQube:** Runs static analysis, checks Quality Gate.
- **Deploy:** Helm deploys the chart from `flask-app/` to namespace `default`.
- **Smoke Test:**  
  Runs inside the cluster:
  ```
  kubectl run curltest --rm -i --restart=Never --image=curlimages/curl -n default -- \
    curl --fail http://flask-app-helm:5000
  ```
  If the app is not reachable, the pipeline fails.

- **Notifications:**  
  Email is sent to `exact84@gmail.com` on success or failure.

## SonarQube Quality Gate

- The pipeline will fail if the SonarQube Quality Gate is not passed.
- Check the SonarQube dashboard for details on issues and coverage.

## Uninstall the Application

```sh
helm uninstall flask-app
```
