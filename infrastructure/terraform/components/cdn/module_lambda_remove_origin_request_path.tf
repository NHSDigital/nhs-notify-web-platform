module "lambda_remove_origin_request_path" {
  source = "../../modules/lambda"
  providers = {
    aws = aws.us-east-1
  }

  function_name = "remove-origin-request-path"
  description   = "A function for removing the request path on origin requests"

  log_retention_in_days = var.log_retention_in_days
  kms_key_arn           = module.kms.key_arn

  iam_policy_document = {
    body = data.aws_iam_policy_document.lambda_remove_origin_request_path.json
  }

  function_s3_bucket      = local.acct.s3_buckets["lambda_function_artefacts"]["id"]
  function_code_base_path = local.aws_lambda_functions_dir_path
  function_code_dir       = "remove-origin-request-path/src"
  function_include_common = true
  function_module_name    = "index"
  handler_function_name   = "handler"
  runtime                 = "nodejs20.x"
  memory                  = 128
  timeout                 = 30
  log_level               = var.log_level

  aws_account_id = var.aws_account_id
  component      = var.component
  environment    = var.environment
  project        = var.project
  region         = "us-east-1"
  group          = var.group

  force_lambda_code_deploy = var.force_lambda_code_deploy
  enable_lambda_insights   = false
}

data "aws_iam_policy_document" "lambda_remove_origin_request_path" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup"
    ]

    # Lambda@Edge logs are logged into Log Groups in the region of the edge location
    # that executes the code. Because of this, we need to allow the lambda role to create
    # Log Groups in other regions
    resources = ["*"]
  }

  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"]

    resources = [
      module.kms.key_arn,
    ]
  }
}
