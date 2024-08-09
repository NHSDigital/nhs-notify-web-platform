# resource "aws_lambda_permission" "cloudfront_lambda_remove_origin_request_path" {
#   statement_id  = "AllowLambdaAtEdgeExecutionFromCloudFrontGateway"
#   principal     = "replicator.lambda.amazonaws.com"
#   action        = "lambda:GetFunction"
#   function_name = module.lambda_remove_origin_request_path.function_name
#   source_arn    = module.lambda_remove_origin_request_path.function_version_arn
# }
