# AWS VPC Infrastructure for Kubernetes (with Terraform)

This project sets up the basic networking infrastructure required to deploy a Kubernetes (K8s) cluster on AWS using Terraform.

---

## Infrastructure Overview

The Terraform code provisions:

- ✅ A custom **VPC** (`k8s-vpc`)
- ✅ 2 **Public subnets** (in `us-east-1a` and `us-east-1b`)
- ✅ 2 **Private subnets** (in `us-east-1a` and `us-east-1b`)
- ✅ An **Internet Gateway** for public internet access
- ✅ A **NAT Gateway** for outbound internet access from private subnets
- ✅ Proper **Routing tables** for public and private traffic flow
- ✅ A **Bastion host** (jump box) for SSH access to private subnets
- ✅ **Security Groups** to control instance access
- ✅ **Network ACLs** for subnet-level traffic rules

---

## File Structure

terraform-proj/  
├── main.tf # VPC and common resources  
├── subnets.tf # Public and private subnets  
├── routes.tf # Route tables and associations  
├── nat.tf # NAT Gateway and EIP  
├── bastion.tf # EC2 Bastion Host  
├── security.tf # Security groups  
├── nacls.tf # Network ACLs  
├── private_instance.tf # Private instance  
├── variables.tf # Input variables  
├── outputs.tf # Useful output (e.g., bastion IP)  
├── terraform.tfvars # Variable values  
└── .github/  
&nbsp;&nbsp;└── workflows/  
&nbsp;&nbsp;&nbsp;&nbsp;└── terraform.yml # GitHub Actions: check + plan + apply  
&nbsp;&nbsp;&nbsp;&nbsp;└── terraform-destroy.yml # GitHub Actions: safe teardown  

---

## Getting Started

### Prerequisites
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- AWS credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
- SSH key pair (create in AWS Console or locally)

### Deploy the Infrastructure

Creation S3:
bootstrap:
	cd bootstrap && terraform init && terraform apply -auto-approve


```
terraform init
terraform plan
terraform apply
```

> `terraform apply` will create real AWS resources — charges may apply.

---

## Connecting to the Bastion Host

1. Use the output from `terraform apply` to get the bastion IP:
   ```
   ssh -i ~/.ssh/k8s-key.pem ec2-user@<BASTION_PUBLIC_IP>
   ```

2. From the bastion, you can SSH into private instances (once created).

---

## GitHub Actions Pipeline

GitHub Actions is configured to run on every `pull_request` to the `main` branch.

Workflow location:
```
.github/workflows/terraform.yml
```

Steps:
- `terraform fmt` and `validate`
- `terraform plan`
- `terraform apply`

---

## Backend (S3/DynamoDB) — Manual Bootstrap

Before using any Terraform commands or running the pipeline, you must manually create the backend for state and locking:

```
make bootstrap
```
This will create the S3 bucket and DynamoDB table required for storing Terraform state and locks. **This step is required only once before the first deployment.**

**Why manual?**
- This approach prevents accidental loss of state/history and ensures full control over backend lifecycle.
- Backend is not deleted automatically to keep the state and history for audit and safety.

To destroy the backend (S3 + DynamoDB) manually:
```
make destroy-bootstrap
```

---

## Infrastructure Teardown

To delete all AWS resources (except backend), use the GitHub Actions workflow:
- Go to GitHub → Actions → `Terraform Destroy` → Run workflow

This will remove all infrastructure, but **the backend (S3/DynamoDB) will remain** for safety and traceability.

To remove the backend completely, run:
```
make destroy-bootstrap
```