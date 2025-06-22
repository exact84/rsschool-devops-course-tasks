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
&nbsp;&nbsp;&nbsp;&nbsp;└── deploy.yml # GitHub Actions workflow  

---

## Getting Started

### Prerequisites
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- AWS credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
- SSH key pair (create in AWS Console or locally)

### Deploy the Infrastructure

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

GitHub Actions is configured to run on every `push` to the `main` and `task_2` and `pull_request` to the `main` branch.

Workflow location:
```
.github/workflows/terraform.yml
```

Steps:
- `terraform fmt` and `validate`
- `terraform plan`

---

## 🧹 Teardown

To destroy all AWS resources:
```
terraform destroy
```