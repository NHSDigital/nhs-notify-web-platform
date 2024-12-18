resource "aws_ssm_parameter" "cdn_authorization_header_secret" {
  count = var.cdn_authorization_header_secret != "unset" ? 1 : 0

  name  = "/${local.csi}/cdn_authorization_header_secret"
  type  = "String"
  value = var.cdn_authorization_header_secret
}
