output "cloudfront_distribution_url" {
  description = "Cloudfront distribution URL"
  value       = "https://${aws_cloudfront_distribution.main.domain_name}"
}

output "cloudfront_distribution_aliases" {
  description = "Cloudfront distribution custom alias URLs"
  value       = formatlist("https://%s", aws_cloudfront_distribution.main.aliases)
}
