# Terraform GitHub Actions Infrastructure

## Description

The infrastructure creates:
- IAM role (`GithubActionsRole`) for GitHub Actions with OIDC
- CI/CD pipeline via GitHub Actions

---

## Variables  
defined in `variables.tf` and stored in GitHub Actions secrets

- `role_name` — name of the IAM role for GitHub Actions  
- `aws_account_id` — AWS account ID  
- `repo_fullname` — repository in the format `owner/repo`  
- `aws_region` — AWS region  

---

## Usage

The infrastructure is deployed automatically via GitHub Actions.  
Workflow file: `.github/workflows/deploy.yml`.

For local testing and debugging you can use Terraform manually:  
1. Clone the repository  

2. Set environment variables  

3. Initialize Terraform:  
terraform init  

4. Review the plan:  
terraform plan  

5. Apply the infrastructure:  
terraform apply  

---

## MFA

An IAM user with Multi-Factor Authentication (MFA) is created in the IAM console.

---

## Note

The S3 bucket for storing Terraform state created manually.

---

## Project structure

terraform-proj/  
├─ backend.tf  
├─ iam-role.tf  
├─ variables.tf  
└─ .github/  
&nbsp;&nbsp;&nbsp;&nbsp;   └─ workflows/  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        └─ deploy.yml  
