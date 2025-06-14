terraform {
  backend "s3" {
    bucket  = var.backend_bucket
    key     = var.backend_key
    region  = var.aws_region
    encrypt = true
    # use_lockfile = true 
  }
}
