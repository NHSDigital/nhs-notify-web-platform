resource "aws_route53_delegation_set" "main" {
  reference_name = "web-gateway.${var.root_domain_name}"
}
