# Flask App Helm Deployment Deployment via Jenkins Pipeline

## Project Structure

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


## minikube and helm must be installed

## Install Jenkins

```
helm install jenkins jenkins/jenkins --namespace default
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

## Personal access token
Create Personal access tokens (classic) in GitHub.
Add it to Jenkins: “Manage Jenkins” → “Credentials” → (global) → “Add Credentials”






## Build and Publish Docker Image

1. Build the image locally:
   ```sh
   docker build -t flask-app:latest ./flask-app
   ```
2. Load the image into minikube:
   ```sh
   minikube image load flask-app:latest
   ```
3. Push the image to Docker Hub:
   ```sh
   docker tag flask-app:latest exact84/flask-app:latest
   docker push exact84/flask-app:latest
   ```

## Deploy the Application with Helm

1. Go to the directory with the Helm chart:
   ```sh
   cd flask-app
   ```
2. Install the application:
   ```sh
   helm install flask-app .
   ```
   To upgrade:
   ```sh
   helm upgrade flask-app .
   ```

## Accessing the Application


## Uninstall the Application

```sh
helm uninstall flask-app
```

## Notes

