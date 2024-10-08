resource "aws_iam_policy" "static_assets_access" {
  name        = "${local.csi}-static-assets-access"
  description = "Access policy to allow access to static website assets in S3"
  path        = "/"
  policy      = data.aws_iam_policy_document.static_assets_access.json
}

data "aws_iam_policy_document" "static_assets_access" {
  statement {
    sid    = "AllowS3Read"
    effect = "Allow"

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      aws_s3_bucket.static_assets.arn,
      "${aws_s3_bucket.static_assets.arn}/*",
    ]
  }
}
