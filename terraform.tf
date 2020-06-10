terraform {
  required_version = "> 0.12.0"
  required_providers {
    aws = "~> 2.62"
  }
  backend "s3" {
    bucket  = "dcbear-engineering-dev-tfstate"
    key     = "tfstates/domo-ec2"
    region  = "us-east-2"
    encrypt = true
  }
}

provider "aws" {
  region  = "us-east-2"
}

provider "venafi" {
  version = "~> 0.9"
}

provider "local" {
  version = "~> 1.4"
}
