resource "aws_s3_bucket" "img" {
  bucket = "${var.prefix}-images"

  tags = var.common_tags
}
resource "aws_s3_bucket_public_access_block" "img" {
  bucket = aws_s3_bucket.img.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_cors_configuration" "img" {
  bucket = aws_s3_bucket.img.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
  }
}

# resource "aws_ssm_parameter" "AWS_STORAGE_BUCKET_NAME" {
#   name        = "/be/${terraform.workspace}/${var.project_name}/AWS_STORAGE_BUCKET_NAME"
#   description = "name of the bucket for storing images"
#   value       = aws_s3_bucket.img.id
#   type        = "SecureString"
#   tags        = var.common_tags
# }

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.img.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket     = aws_s3_bucket.img.bucket
  depends_on = [aws_s3_bucket_public_access_block.img]
  policy     = <<EOF
    {
      "Version": "2012-10-17",
      "Id": "MakeObjectsPublic",
      "Statement": [
          {
              "Sid": "AllowCloudFrontServicePrincipal",
              "Effect": "Allow",
              "Principal": "*",
              "Action": "s3:GetObject",
              "Resource": [
                  "${aws_s3_bucket.img.arn}/*",
                  "${aws_s3_bucket.img.arn}"
              ]
          }
      ]
    }
    EOF
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = aws_s3_bucket.img.id
  description                       = ""
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_acm_certificate" "certificate_img" {
  domain_name       = "*.${var.root_domain_name}"
  validation_method = "DNS"
  tags              = var.common_tags
  provider          = aws.certificate

  lifecycle {
    create_before_destroy = true
  }
}
provider "aws" {
  shared_config_files = var.config_file_path
  region              = "us-east-1"
  profile             = local.environment
  alias               = "certificate"
}

locals {
  environment = terraform.workspace
}
resource "aws_cloudfront_distribution" "cloudfront_img" {
  origin {
    domain_name              = "${aws_s3_bucket.img.id}.s3.${var.region}.amazonaws.com"
    origin_id                = aws_s3_bucket.img.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }
  retain_on_delete = true
  enabled          = true
  is_ipv6_enabled  = true
  comment          = "${aws_s3_bucket.img.id} CloudFront Distribution"
  price_class      = var.cloudfront_price_class
  aliases          = ["${var.img_domain_name}"]
  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.img.id
    viewer_protocol_policy = "redirect-to-https"

  }

  default_root_object = ""

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate_img.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
