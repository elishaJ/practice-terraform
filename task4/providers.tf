terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

provider "aws" {
  alias  = "N-Virginia"
  region = "us-east-1"
}


provider "aws" {
  alias  = "Oregon"
  region = "us-west-2"
}

