resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "NHS Notify ${var.module} CDN (${var.parameter_bundle.environment})"
  default_root_object = var.root_object
  price_class         = "PriceClass_100"
  web_acl_id          = var.cdn_waf_acl_arn

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  # aliases = [
  #   var.cloudfront_fqdn,
  # ]

  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn      = aws_acm_certificate.frontend.arn
    # minimum_protocol_version = "TLSv1.2_2021"
    # ssl_support_method       = "sni-only"
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.cdn_logs.bucket_regional_domain_name
  }

  # Static Assets bucket S3 origin
  origin {
    domain_name = aws_s3_bucket.static_assets.bucket_regional_domain_name
    origin_id   = "${local.csi}-origin-static"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_assets.cloudfront_access_identity_path
    }
  }

  # Static assets S3 content
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.csi}-origin-static"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.cloudfront_min_ttl
    default_ttl            = var.cloudfront_default_ttl
    max_ttl                = var.cloudfront_max_ttl
    compress               = true
  }

  dynamic "custom_error_response" {
    for_each = local.cloudfront_error_map
    content {
      error_caching_min_ttl = 0
      error_code            = custom_error_response.value.error_code
      response_page_path    = custom_error_response.value.response_page_path
      response_code         = custom_error_response.value.response_code
    }
  }

  depends_on = [
    aws_s3_bucket_policy.static_assets
  ]
}

