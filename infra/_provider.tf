provider "aws" {
    shared_credentials_files = ["~/.aws/credentials"]
    region =                  "${var.aws_region}"
}

provider "aws" {
    shared_credentials_files = ["~/.aws/credentials"]
     alias = "us-east-1"
     region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}