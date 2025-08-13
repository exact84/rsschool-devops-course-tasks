terraform {
  backend "s3" {
    bucket         = "k8s-terraform-state-140484"
    key            = "terraform/k8s-vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
