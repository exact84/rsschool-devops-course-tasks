variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "bucket_name" {
  default = "your-unique-terraform-bucket"
}

variable "table_name" {
  default = "terraform-locks"
}
