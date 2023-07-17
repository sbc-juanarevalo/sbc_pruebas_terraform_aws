variable "varcf_bucket_regional_domain_name" {
    type = string
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "Some comment"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.varcf_bucket_regional_domain_name
    origin_id   = "myS3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  

  # AWS Managed Caching Policy (CachingDisabled)
  default_cache_behavior {
    # Using the CachingDisabled managed policy ID:
    cache_policy_id  = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    //path_pattern     = "/content/*"
    target_origin_id = local.s3_origin_id
         
  }  

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CO"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  # ... other configuration ...

}