terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform/k8s-vpc/terraform.tfstate"
    region         = var.region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
