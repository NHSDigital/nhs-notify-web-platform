module "web_ui_frontend" {
  source = "../../modules/web-frontend"

  providers = {
    aws           = aws,
    aws.us-east-1 = aws.us-east-1
  }

  parameter_bundle          = local.parameter_bundle
  pipeline_component_static = "test"

  root_object = "index"

  cloudfront_fqdn = "null" //var.cloudfront_fqdn
  route53_zone_id = "null" //var.route53_zone_id

  cdn_waf_acl_arn = aws_wafv2_web_acl.cdn_no_allowlist.arn

  bucket_logging_bucket = aws_s3_bucket.access_logs.bucket

}
