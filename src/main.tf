provider "aws" {
  region = "us-east-2"
}

variable "branch_name" {
  description = "nombre de la rama"
}

module "s3" {
    source = "./modules/sbc-module-s3"
    vars3_branch = var.branch_name
}


