terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform/k8s-vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
