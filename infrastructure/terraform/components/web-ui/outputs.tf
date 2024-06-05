output "deployment_account_id" {
  description = "AWS Account ID of the account we are deploying into right now"
  value       = var.account_ids[var.account_name]
}

output "deployment_account_name" {
  description = "AWS Account ID of the account we are deploying into right now"
  value       = var.account_name
}
