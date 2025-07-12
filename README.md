# Flask App Helm Deployment

## Project Structure

- flask-app/
  - .helmignore
  - Dockerfile
  - main.py
  - Chart.yaml
  - values.yaml
  - requirements.txt
  - templates/
     - ... (deployment.yaml, service.yaml, etc.)

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

- **Recommended way for minikube:**
  ```sh
  minikube service flask-app
  ```
  This command will open a browser with the working address (e.g., http://127.0.0.1:63546/).

- **NodePort (e.g., http://192.168.49.2:30202/):**
  May not be accessible from outside the minikube VM on Windows/Mac. This is a minikube limitation, not your configuration.

## Uninstall the Application

```sh
helm uninstall flask-app
```

## Notes
- For production, it is recommended to:
   - Store the image in a public registry (e.g., DockerHub).
   - Update values.yaml to set image.repository: exact84/flask-app and image.tag: latest.
- The application is built with Flask and runs in development mode (suitable for demo, not for production).
