terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias = "us-east-2"
  region = "us-east-2"
}

provider "aws" {
  alias = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias = "us-west-2"
  region = "us-west-2"
}
