variable "domainName" {
  default = "www.dashboard.ha-serverless.devopslord.com"
  type    = string
}

variable "bucketName" {
  default = "www.dashboard.ha-serverless.devopslord.com"
  type    = string
}

variable "zone_id" {
  type = string
}

resource "aws_s3_bucket" "www-my-aws-project-com" {
  bucket = var.bucketName
}




resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.www-my-aws-project-com.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "my-config" {
  bucket = aws_s3_bucket.www-my-aws-project-com.id
  index_document {
    suffix = "index.html"
  }
}

locals {
    mime_types = {
      ".html" = "text/html"
      ".png"  = "image/png"
      ".jpg"  = "image/jpeg"
      ".gif"  = "image/gif"
      ".css"  = "text/css"
      ".js"   = "application/javascript"
    }
}

resource "aws_s3_object" "build" {
  for_each = fileset("./src/dashboard/", "**")
  bucket = aws_s3_bucket.www-my-aws-project-com.id
  key = each.value
  source = "./src/dashboard/${each.value}"
  etag = filemd5("./src/dashboard/${each.value}")
  acl    = "public-read"
content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
}

##################################################
# cloudfornt
##################################################

resource "aws_cloudfront_distribution" "my-distribution" {
  origin {
    domain_name              = aws_s3_bucket.www-my-aws-project-com.bucket_regional_domain_name
    origin_id   = "S3-Origin"
  }


  aliases = [var.domainName]

  enabled = true
    default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Origin"

    viewer_protocol_policy = "redirect-to-https"

    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

  }


  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert-my-aws-project-com.arn
    ssl_support_method = "sni-only"
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [
    aws_acm_certificate.cert-my-aws-project-com,
  ]
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.my-distribution.domain_name
}

resource "aws_acm_certificate" "cert-my-aws-project-com" {
  domain_name       = var.domainName
  validation_method = "DNS"
    subject_alternative_names = [var.domainName, "dashboard.ha-serverless.devopslord.com"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn         = aws_acm_certificate.cert-my-aws-project-com.arn
  validation_record_fqdns = [for record in aws_route53_record.cert-validation-record : record.fqdn]
}


resource "aws_route53_record" "cert-validation-record" {
  for_each = {
    for dvo in aws_acm_certificate.cert-my-aws-project-com.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = var.domainName
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.my-distribution.hosted_zone_id
    evaluate_target_health = false
  }
}