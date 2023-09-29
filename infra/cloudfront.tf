resource "aws_s3_bucket" "supermarket_s3_bucket" {
  bucket = "supermarket-cloudfront-bucket"
}


# Create a CloudFront distribution
resource "aws_cloudfront_distribution" "supermarket_distribution" {
  origin {
    domain_name = aws_lb.supermarket-app-lb.dns_name
    origin_id   = "supermarket-alb-origin"
    custom_origin_config {
      http_port           = 8080
      https_port          = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  #is_ipv6_enabled     = true
  default_root_object = "" # Change to your default root object

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Viewer settings
  default_cache_behavior {
    target_origin_id = "supermarket-alb-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    min_ttl          = 0
    default_ttl      = 3600
    max_ttl          = 86400

    forwarded_values {
      query_string = false # Set to true if you want to forward query strings
      cookies {
        forward = "none" # Options: "all", "none", "whitelist"
      }
      headers = [] # List of headers to forward, e.g., ["Authorization"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}