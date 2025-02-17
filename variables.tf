variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "environment" {
  type = string
  description = "Infrastructure environmnet (i.e. dev, prod, etc)"
  default = "dev"
}

variable "private_subnet_cidr" {
  type = string
  description = "CIDR block for the private subnet"
  default = "10.0.1.0/26"
}

variable "public_subnet_cidr" {
  type = string
  description = "CIDR block for the private subnet"
  default = "10.0.2.0/26"
}

variable "trusted_ips" {
  type = list(string)
  description = "List of trusted IP addresses for SSH access"
  default = [ "70.110.18.115/32", "68.80.7.165/32" ]
}