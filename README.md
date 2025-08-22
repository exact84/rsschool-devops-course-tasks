# Task 7: Prometheus Deployment on K8s

## Prerequisites

Ensure the following tools and configurations are in place:

Minikube is installed and the local Kubernetes cluster is running:

``` minikube start ```  

kubectl is installed and configured:

``` kubectl get nodes ```  

Helm is installed:

``` helm version ```  

Add the Prometheus Community Helm repository (required for Prometheus and Grafana charts):
````
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
````

## Install Prometheus

```
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```

 - This will install:
 - Prometheus server
 - Node exporter
 - Kube State Metrics
 - Alertmanager

Check if all components are running:

``` kubectl get all -n monitoring ```

To access the Prometheus dashboard locally:
``` kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090 ```

## Install Grafana

Install Grafana in the same monitoring namespace:
```
helm repo add grafana https://grafana.github.io/helm-charts &&
helm repo update &&
helm install grafana grafana/grafana
  --namespace monitoring \
  --set admin.password=admin123 \
  --set service.type=ClusterIP \
  --set persistence.enabled=true \
  --set persistence.size=1Gi \
  --set grafana.ini.server.root_url="http://localhost:3000/" \
  --set grafana.ini.auth.anonymous.enabled=true

```
Change the admin password (admin123) to a secure one in production environments.

Check if Grafana is running:
``` kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana ```

To access the Grafana dashboard locally:
``` kubectl port-forward svc/grafana 3000:3000 -n monitoring ```

## Prometheus Data Source Configuration

Once inside Grafana:

 - Connections → Add new connection
 - Click Add data source
 - Select Prometheus
 - Click Add new data source
 - Set the URL to:
http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090
 - Click Save & Test

You should see a success message indicating Grafana can reach Prometheus (Successfully queried the Prometheus API.)

## Dashboard Creation

To quickly get started with a ready-made dashboard for node metrics, you can import a public dashboard from Grafana’s community dashboards.

In Grafana, 
 - Dashboard
 - Click Create Dashboard
 - Click Import dashboard, enter the dashboard ID: 1860, click Load
 - Select prometheus data source, click Import
This is the "Node Exporter Full" dashboard commonly used for Kubernetes node metrics.

To save the dashboard:

At the top-right
 - Save dashboard -> Save
 - Enter a name (e.g., Node Metrics)
 - Click Save

## Export Dashboard JSON
To include the dashboard layout in your repository:

 - Open the dashboard
 - Click Export -> Export as JSON
 - Click Download file or Copy to clipboart to save the contents to a file.

## Alert Configuration

### Alert Rules (PrometheusRule)

Alert rules are configured via PrometheusRule CRD in `monitoring/prometheus/alert-rules.yaml`:

- **HighCPUUsage**: Triggers when CPU usage > 70% (immediate alert)
- **LowMemoryAvailable**: Triggers when available memory < 25% (immediate alert)

Apply alert rules:
```
kubectl apply -f monitoring/prometheus/alert-rules.yaml
```

### Contact Points and Notification Policies

Email notifications are configured via Grafana provisioning in `monitoring/grafana/grafana-unified-alerting.yaml`:

- **Contact Point**: `email-alerts` with SMTP4Dev integration
- **Notification Policies**: Different routing for warning/critical alerts
- **SMTP Configuration**: Uses local smtp4dev service (no authentication required)

Apply Grafana alerting configuration:
```
kubectl apply -f monitoring/grafana/grafana-unified-alerting.yaml
```

Update Prometheus stack with alerts settings:
```
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values monitoring/grafana/prometheus-stack-values.yaml \
  --reuse-values
kubectl apply -f monitoring/prometheus/alertmanager-values.yaml
```

### Testing Alerts

Access SMTP4Dev web interface to view received emails:
```
kubectl port-forward svc/smtp4dev 8080:80 -n monitoring
```

Create stress tests to trigger alerts:

**CPU stress:**
```
kubectl run cpu-stress --image=polinux/stress --rm -it --restart=Never -- stress --cpu 2 --timeout 300s
```

**Memory stress:**
```
kubectl run memory-stress --image=polinux/stress --rm -it --restart=Never -- stress --vm 1 --vm-bytes 1G --timeout 300s
```

### Project Structure (Monitoring)

```
monitoring/
├── Jenkinsfile # pipeline
├── prometheus/
│   ├── alert-rules.yaml              # PrometheusRule: CPU/Memory alerts
│   ├── alertmanager-values.yaml      # Alertmanager Helm values
│   └── smtp4dev.yaml                 # SMTP4Dev deployment/config
└── grafana/
    ├── prometheus-stack-values.yaml  # Helm values for SMTP configuration
    └── grafana-unified-alerting.yaml # Contact points and notification policies
```

Restart the pod or wait for the rollout:
```
kubectl rollout restart deploy prometheus-grafana -n monitoring
```

# Also You can use Jenkins Pipeline Implementation

The monitoring setup is automated via Jenkins pipeline that:
1. Validates cluster availability before deployment
2. Uses internal Kubernetes DNS for service communication
3. Implements proper sequencing of deployments:
   - Infrastructure (Prometheus, Grafana)
   - Configurations (Alert rules, SMTP)
   - Service restart
   - Data source and dashboard setup

### Pipeline Requirements
- Jenkins agent with kubectl and helm
- Access to Kubernetes cluster
- Network connectivity between Jenkins and cluster services
- Appropriate RBAC permissions


  ---  
  ---  
# Task 6: Application Deployment via Jenkins Pipeline

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

## Jenkins Pipeline Details

The pipeline automates the following steps:
1. Validates Kubernetes cluster availability
2. Sets up Helm repositories
3. Installs Prometheus and Grafana
4. Configures alerting and monitoring
5. Sets up data sources and dashboards
6. Verifies the deployment

### Pipeline Requirements
- Jenkins needs access to kubectl and helm
- Service account with appropriate RBAC permissions
- Network access to Kubernetes cluster
- Access to Grafana API from Jenkins pod
