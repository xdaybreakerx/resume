terraform {
  cloud {

    organization = "xander-salathe-cloud-resume"

    workspaces {
      name = "resume-deployment"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cloud_resume_bucket" {
  bucket = "xander-salathe-cloud-resume-bucket"
}

resource "aws_cloudfront_distribution" "resume_cdn" {
  origin {
    domain_name              = aws_s3_bucket.cloud_resume_bucket.bucket_regional_domain_name
    origin_id                = "ResumeS3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.resume_oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:911167911932:certificate/251685e5-1bcb-4b4a-a16c-7ff8633f280f"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  aliases = ["resume.xandersalathe.com"]

  default_cache_behavior {
    target_origin_id       = "ResumeS3Origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = aws_cloudfront_cache_policy.resume_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.resume_request_policy.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

resource "aws_cloudfront_origin_access_control" "resume_oac" {
  name                              = "ResumeOAC"
  description                       = "OAC for CloudFront to access Resume S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_cache_policy" "resume_cache_policy" {
  name    = "ResumeCachePolicy"
  comment = "Cache policy for resume website"

  default_ttl = 86400    # Cache for 1 day
  max_ttl     = 31536000 # Maximum 1 year
  min_ttl     = 0        # Allow immediate updates

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "resume_request_policy" {
  name    = "ResumeRequestPolicy"
  comment = "Origin request policy for resume S3"

  headers_config {
    header_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }

  cookies_config {
    cookie_behavior = "none"
  }
}


resource "aws_s3_bucket_policy" "resume_bucket_policy" {
  bucket = aws_s3_bucket.cloud_resume_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.cloud_resume_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::911167911932:distribution/${aws_cloudfront_distribution.resume_cdn.id}"
          }
        }
      }
    ]
  })
}
