output "static_bucket" {
  value = aws_s3_bucket.static_assets
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}

