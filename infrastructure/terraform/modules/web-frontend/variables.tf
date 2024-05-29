variable "module" {
  type        = string
  description = "The variable encapsulating the name of this module"
  default     = "fe"
}

variable "parameter_bundle" {
  type = object(
    {
      project                             = string
      environment                         = string
      component                           = string
      group                               = string
      region                              = string
      account_ids                         = map(string)
      account_name                        = string
      default_kms_deletion_window_in_days = number
      default_tags                        = map(string)
      iam_resource_arns                   = map(string)
      cicd_bucket_name                    = optional(string)
      pipeline_overrides                  = map(any)
    }
  )
  description = "Contains all of the default parameters needed by any module in this project"
}

variable "pipeline_component_static" {
  description = "Name of the pipeline component for the static content"
  type        = string
}

variable "root_object" {
  type        = string
  description = "default_root_object for cloudfront. If not set, then the first element of var.web_path_patterns is used"
  default     = ""
}

variable "cloudfront_fqdn" {
  type        = string
  description = "CloudFront fully qualified domain name"
}

variable "route53_zone_id" {
  type        = string
  description = "ID of the Route53 Public Hosted Zone in which to create cloudfront records for the front end"
}

variable "cdn_waf_acl_arn" {
  type        = string
  description = "ARN of the WAF Access Control List to use to protect the CloudFront Distribution"
}

variable "cloudfront_min_ttl" {
  type        = number
  description = "The minimum amount of time (in seconds) that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated"
  default     = 0 # 0 minutes
}

variable "cloudfront_max_ttl" {
  type        = number
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated"
  default     = 86400 # 1 day
}

variable "cloudfront_default_ttl" {
  type        = number
  description = "The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header"
  default     = 0 # 0 minutes
}

variable "bucket_logging_bucket" {
  type        = string
  description = "Name of the bucket access logging bucket"
}
