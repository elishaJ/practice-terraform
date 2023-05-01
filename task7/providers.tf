terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  alias  = "Virginia"
  region = "us-east-1"
}

