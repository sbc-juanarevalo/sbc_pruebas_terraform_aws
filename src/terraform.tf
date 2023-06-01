terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }

  backend "s3" {
    key    = "terraform/orbika/tfstate"
    region = "us-east-1"
  }

}