###########################################################################
# CLOUDFRONT ALIASES
#
# Combines the automatic local root domain name (from Route 53) with the
# below custom external aliases which are configured  per environment
###########################################################################

locals {
  external_aliases = {
    main-prod    = ["prod.notify.nhs.uk"]
    main-nonprod = ["nonprod.notify.nhs.uk"]
  }

  this_environment_key               = "main-${var.environment}"
  this_environment_aliases           = lookup(local.external_aliases, local.this_environment_key, [])
  this_environment_aliases_with_root = concat(local.this_environment_aliases, [local.root_domain_name])
}
