
# Kubernetes Cluster Setup on K3s in AWS

## Project Overview
This guide outlines the setup of a Kubernetes cluster using K3s, consisting of one master node and one worker node, deployed in separate private subnets within an AWS VPC. Access to the cluster is facilitated through a bastion host located in a public subnet.

## Requirements and Preparation

### 1. Deploy Kubernetes Cluster Infrastructure with Terraform
The project includes Terraform configurations to create a VPC, private subnets for the master and worker nodes, EC2 instances for the master and worker, a bastion host, and necessary security settings.

Run the following commands:

```
terraform init
terraform plan
terraform apply
```

### 2. SSH Key for Access
An SSH key (`k8s-key.pem`) generated during the creation of EC2 instances in AWS is used to connect to the instances.

### 3. Install kubectl on Local Machine (Windows)
- Install [Chocolatey](https://chocolatey.org/install) if not already installed.
- Open PowerShell as an administrator and run:

```
choco install kubernetes-cli -y
```

---

## Deploying the Kubernetes Cluster

### 1. Install K3s on the Master Node
- Copy the SSH key and connect to the master EC2 instance.
- Set appropriate permissions for the key.
- Install the K3s server:

```
curl -sfL https://get.k3s.io | sh -s - server
```

- Retrieve the node token:

```
sudo cat /var/lib/rancher/k3s/server/node-token
```
---

### 2. Install K3s Agent on the Worker Node
- Connect to the worker EC2 instance via SSH.
- Install the K3s agent, specifying the server URL and token:

```
curl -sfL https://get.k3s.io | K3S_URL=https://<MASTER_PRIVATE_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -s - agent
```
---


## Configuring Cluster Access from Local Machine

### 1. Create an SSH Tunnel via Bastion Host
Run the following command on your local machine to forward the port to the API server:

```
ssh -i path\to\k8s-key.pem -L 6443:<MASTER_PRIVATE_IP>:6443 ec2-user@<BASTION_PUBLIC_IP>
```

Keep this terminal window open to maintain the tunnel.

### 2. Copy the kubeconfig File
From the bastion host, retrieve the kubeconfig file from the master node and save it locally:

```
ssh -i path/to/k8s-key.pem ec2-user@<BASTION_PUBLIC_IP> "ssh ec2-user@<MASTER_PRIVATE_IP> 'sudo cat /etc/rancher/k3s/k3s.yaml'" > k3s.yaml
```
---


### 3. Edit the kubeconfig File
Open `k3s.yaml` in a text editor and update the `clusters.cluster.server` field to:

```
https://localhost:6443
```
---

### 4. Set the KUBECONFIG Environment Variable (Windows PowerShell)

```
$env:KUBECONFIG = "C:\pathTo\k3s.yaml"
```
---

### 5. Verify Access
In the same session with the SSH tunnel active, check the list of nodes:

```
kubectl get nodes
```

If the nodes appear with a `Ready` status, the setup is successful.

## Deploy a Workload
Deploy a simple nginx application:

```
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
kubectl get all --all-namespaces | grep nginx
```
---
