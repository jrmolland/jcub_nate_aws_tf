terraform {
  
  /*backend "remote" {
    hostname = "app.terraform.io"
    organization = "jcub"
    
    workspaces {
      name = "jcub_nate_prod"
    }
  }
  */

  backend "s3" {
    bucket = "jcub-nate-tf-state"
    key = "prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }

  required_version = "> 1.10.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

# This is an update
# Another 


#This should work now.