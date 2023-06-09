variable "vars3_branch" {
  type = string
}


resource "aws_s3_bucket" "webtest2" {
  bucket = "juanfelipe-tf-example"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.webtest2.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.webtest2.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.webtest2.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.webtest2.id
  acl    = "public-read"
}


resource "aws_s3_object" "object1" {
  depends_on = [aws_s3_bucket_website_configuration.example]
  bucket = aws_s3_bucket.webtest2.bucket
  key = "index.html"
  acl = "public-read"
  content = var.vars3_branch
  content_type = "text/html"
}

output "vars3_bucket_regional_domain_name" {
    value = aws_s3_bucket.webtest2.bucket_regional_domain_name  
}