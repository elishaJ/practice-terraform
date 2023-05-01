terraform {
  backend "s3" {
  }
}

provider "aws" {
  alias  = "Virginia"
  region = "us-east-1"
}

