# resource "aws_acm_certificate" "frontend" {
#   provider          = aws.us-east-1
#   domain_name       = var.cloudfront_fqdn
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "frontend" {
#   for_each = {
#     for dvo in aws_acm_certificate.frontend.domain_validation_options :
#     dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   type            = each.value.type
#   zone_id         = var.route53_zone_id
#   ttl             = 300
# }

# resource "aws_acm_certificate_validation" "frontend" {
#   provider        = aws.us-east-1
#   certificate_arn = aws_acm_certificate.frontend.arn

#   validation_record_fqdns = flatten([
#     [
#       for record in aws_route53_record.frontend :
#       record.fqdn
#     ]
#   ])
# }
