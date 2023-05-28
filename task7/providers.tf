terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-bk-007"
    key            = "state/t7/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-lock-table-1292"
    encrypt        = true
    profile        = "default"
  }
}

provider "aws" {
  # Configuration options
}
