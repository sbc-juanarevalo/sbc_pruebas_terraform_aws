provider "aws" {
  region = "us-east-2"
}

module "s3" {
    source = "./modules/sbc-module-s3"  
}

/*module "cloudfront" {
    source = "./modules/sbc-module-cloudfront"
    varcf_bucket_regional_domain_name = module.s3.vars3_bucket_regional_domain_name
  
}*/