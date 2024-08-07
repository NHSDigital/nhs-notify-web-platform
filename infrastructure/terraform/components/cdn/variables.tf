variable "project" {
  type        = string
  description = "The name of the Project we are bootstrapping tfscaffold for"
}

variable "account_ids" {
  type        = map(string)
  description = "All AWS Account IDs for this project"
  default     = {}
}

variable "app_deployer_role_permission_account_ids" {
  type        = map(string)
  description = "All AWS Account IDs for this project that have the AppDeployer role created"
  default     = {}
}

variable "superuser_role_name" {
  type        = string
  description = "Name of the superuser role that is allowed to create other IAM roles"
}

variable "app_deployer_role_name" {
  type        = string
  description = "Name of the app deployer role that is allowed to deploy Comms Mgr applications but not create other IAM roles"
}

variable "account_name" {
  type        = string
  description = "The name of the AWS Account to deploy into (see globals.tfvars)"
}

variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "component" {
  type        = string
  description = "The name of the component"
  default     = "web-ui"
}

variable "group" {
  type        = string
  description = "The group variables are being inherited from (often synonmous with account short-name)"
  default     = "n/a"
}

variable "module" {
  type        = string
  description = "The variable encapsulating the name of this module"
  default     = "n/a"
}

variable "default_kms_deletion_window_in_days" {
  type        = number
  description = "Default number of days to set KMS key deletion window"
  default     = 14
}

variable "pipeline_overrides" {
  type        = string
  description = "All ENV variables from the deployment pipeline that start with OVR_"
}

variable "pipeline_component_static" {
  description = "Name of the pipeline component for the static content"
  type        = string
  default     = "test"
}

variable "root_object" {
  type        = string
  description = "default_root_object for cloudfront. If not set, then the first element of var.web_path_patterns is used"
  default     = ""
}

variable "cloudfront_fqdn" {
  type        = string
  description = "CloudFront fully qualified domain name"
  default     = "test"
}

variable "route53_zone_id" {
  type        = string
  description = "ID of the Route53 Public Hosted Zone in which to create cloudfront records for the front end"
  default     = "test"
}

variable "cloudtrail_log_group_name" {
  type        = string
  description = "The name of the Cloudtrail log group name on the account (see globals.tfvars)"
}

variable "waf_rate_limit_cdn" {
  type        = number
  description = "The rate limit is the maximum number of CDN requests from a single IP address that are allowed in a five-minute period"
  default     = 20000
}

variable "terraform_root_dir" {
  type        = string
  description = "Absolute path to Terraform directory"
}

variable "cloudfront_origins" {
  description = "Cloudfront origin config"
  default     = []
  type = list(object(
    {
      domain_name = optional(string, "")
      origin_id   = optional(string, "")
      origin_path = optional(string, "")
      custom_origin_config = optional(object({
        http_port              = optional(string, "")
        https_port             = optional(string, "")
        origin_protocol_policy = optional(string, "")
        origin_ssl_protocols   = optional(list(string), [])
      }), {})
      custom_header = optional(list(object({
        name  = optional(string, "")
        value = optional(string, "")
      })), [])
      path_pattern    = optional(string, "")
      allowed_methods = optional(list(string), ["GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "DELETE"])
      cached_methods  = optional(list(string), ["GET", "HEAD"])
      cache_policy_id = optional(string, "2e54312d-136d-493c-8eb9-b001f22f67d2") # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html, using Amplify based managed cache policy for behaviour
  }))
}
