variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "backend_bucket" {
  description = "Name of the S3 bucket for Terraform backend"
  type        = string
  default     = "exact-aws-bucket"
}

variable "backend_key" {
  description = "Path to the state file inside the bucket"
  type        = string
  default     = "global/s3/terraform.tfstate"
}

variable "role_name" {
  description = "IAM role name for GitHub Actions"
  type        = string
  default     = "GithubActionsRole"
}

variable "aws_account_id" {
  type        = string
  description = "Your AWS Account ID"
}

variable "repo_fullname" {
  type        = string
  description = "GitHub repo in format owner/name"
  default     = "your-github-username/your-repo"
}