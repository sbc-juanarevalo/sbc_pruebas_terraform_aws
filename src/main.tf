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


module "cloudfront" {
    source = "./modules/sbc-module-cloudfront"
    varcf_bucket_regional_domain_name = module.s3.vars3_bucket_regional_domain_name
  
}