variable "role_name" {
  description = "IAM role name for GitHub Actions"
  type        = string
  default     = "GithubActionsRole"
}

variable "aws_account_id" {
  type        = string
  description = "364777501483"
  default     = "364777501483"
}

variable "repo_fullname" {
  type        = string
  description = "GitHub repo in format owner/name"
  default     = "exact84/rsschool-devops-course-tasks"
}