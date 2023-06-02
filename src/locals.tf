locals {
  aws_region  = "us-east-1"
  company     = "sbc"
  product     = "pruebas-terraform"
  environment = var.branch_name
  prefijo     = "sbc-pruebas-terraform-${var.branch_name}"

  tags = {
    origin     = "terraform"
    enviroment = var.branch_name
    project    = "project-pruebas-terraform"
  }
}