resource "aws_cloudfront_distribution" "main" {
  provider = aws.us-east-1

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "NHS Notify CDN (${local.csi})"
  default_root_object = "index.html"
  price_class         = "PriceClass_100" # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-distributionconfig.html#cfn-cloudfront-distribution-distributionconfig-priceclass
  web_acl_id          = aws_wafv2_web_acl.main.arn

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  aliases = [
    local.root_domain_name
  ]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.main.arn
    minimum_protocol_version = "TLSv1.2_2021" # Supports 1.2 & 1.3 - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html
    ssl_support_method       = "sni-only"
  }

  logging_config {
    bucket          = module.s3bucket_cf_logs.bucket_regional_domain_name
    include_cookies = false
  }

  # CMS-Web Template origin
  origin {
    domain_name = "nhsdigital.github.io"
    origin_path = "/nhs-notify-web-cms"
    origin_id   = "github-nhs-notify-web-cms"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  # Github Web-CMS behaviour
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "github-nhs-notify-web-cms"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = module.lambda_remove_origin_request_path.function_qualified_arn
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }


  # TODO: Custom origin
  # dynamic "origin" {
  #   for_each = var.cloudfront_origins
  #   content {
  #     domain_name = origin.value.domain_name
  #     origin_id   = origin.value.origin_id
  #     origin_path = origin.value.origin_path
  #     custom_origin_config {
  #       http_port              = origin.value.custom_origin_config.http_port
  #       https_port             = origin.value.custom_origin_config.https_port
  #       origin_protocol_policy = origin.value.custom_origin_config.origin_protocol_policy
  #       origin_ssl_protocols   = origin.value.custom_origin_config.origin_ssl_protocols
  #     }
  #     dynamic "custom_header" {
  #       for_each = origin.value.custom_header
  #       content {
  #         name  = custom_header.value.name
  #         value = custom_header.value.value
  #       }
  #     }
  #   }
  # }


#   # Custom behaviour
#   dynamic "ordered_cache_behavior" {
#     for_each = var.cloudfront_origins
#     content {
#       path_pattern     = "/${ordered_cache_behavior.value.path_pattern}*"
#       allowed_methods  = ordered_cache_behavior.value.allowed_methods
#       cached_methods   = ordered_cache_behavior.value.cached_methods
#       target_origin_id = ordered_cache_behavior.value.origin_id

#       cache_policy_id = ordered_cache_behavior.value.cache_policy_id

#       viewer_protocol_policy = "redirect-to-https"
#       min_ttl                = var.cloudfront_min_ttl
#       default_ttl            = var.cloudfront_default_ttl
#       max_ttl                = var.cloudfront_max_ttl
#       compress               = true
#     }
#   }

#   dynamic "custom_error_response" {
#     for_each = local.cloudfront_error_map
#     content {
#       error_caching_min_ttl = 0
#       error_code            = custom_error_response.value.error_code
#       response_page_path    = custom_error_response.value.response_page_path
#       response_code         = custom_error_response.value.response_code
#     }
#   }

}

