terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}

provider "aws" {
  region = var.region
  # access_key = var.aws_access_key_id
  # secret_key = var.aws_secret_key 
}
