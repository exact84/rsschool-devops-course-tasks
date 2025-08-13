variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "bucket_name" {
  default = "k8s-terraform-state-140484"
}

variable "table_name" {
  default = "terraform-locks"
}
