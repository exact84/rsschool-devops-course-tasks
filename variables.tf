variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

// адресное пространство сети
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

//для публичных машин
variable "public_subnets" {
  description = "List of public subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

//для приватных машин
variable "private_subnets" {
  description = "List of private subnet CIDRs"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

//Availability Zones
variable "azs" {
  description = "List of Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}
