variable "role_name" {
  type        = string
  description = "IAM role name for GitHub Actions"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "repo_fullname" {
  type        = string
  description = "GitHub repo in format owner/name"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}