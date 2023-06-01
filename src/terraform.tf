terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }

  backend "ec2" {
    region = "us-east-1"
    ami = "ami-0889a44b331db0194"
    instance_type = "t1.micro"
    tags = {
      "name" = "first_instance"
    }    
  }

  
}