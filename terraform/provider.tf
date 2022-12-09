# provider.tf

# Specify the provider and access details
provider "aws" {
  region                  = "us-east-1"
  profile                 = "default"
  shared_credentials_file = "/home/benjaminvaliente/.aws/credentials"
}

# Specify the terraform state bucket
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    /*     null = {
      source = "hashicorp/null"
    }*/
  }

  backend "s3" {
    bucket                  = "tf-backend-benjaminvaliente"
    key                     = "ecs/terraform.state"
    region                  = "us-east-1"
    profile                 = "default"
    shared_credentials_file = "/home/benjaminvaliente/.aws/credentials"
  }
}