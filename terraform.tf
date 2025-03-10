terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "jcub"
    
    workspaces {
      name = "jcub_nate_prod"
    }
  }
  
  /*
  backend "s3" {
    bucket = "jcub-nate-tfstate"
    key = "prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
  */

  required_version = "~> 1.11.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}