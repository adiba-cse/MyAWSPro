terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"
    }
  }

  backend "s3" {
    bucket               = "mynewbucketfjgvgjm"
    key                  = "state/terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "default"
    encrypt              = true
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}