module "s3bucket_static_content" {
  source = "git::https://github.com/NHSDigital/nhs-notify-shared-modules.git//infrastructure/modules/s3bucket?ref=v1.0.0"

  name = "static-content"

  aws_account_id = var.aws_account_id
  region         = var.region
  project        = var.project
  environment    = var.environment
  component      = var.component

  acl           = "private"
  force_destroy = false
  versioning    = true

  object_ownership = "ObjectWriter"

  lifecycle_rules = [
    {
      prefix  = ""
      enabled = true

      transition = [
        {
          days          = "90"
          storage_class = "STANDARD_IA"
        },
        {
          days          = "180"
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days = "365"
      }


      noncurrent_version_transition = [
        {
          noncurrent_days = "30"
          storage_class   = "STANDARD_IA"
        },
        {
          noncurrent_days = "180"
          storage_class   = "GLACIER"
        }

      ]

      noncurrent_version_expiration = {
        noncurrent_days = "365"
      }

      abort_incomplete_multipart_upload = {
        days = "1"
      }
    }
  ]

  policy_documents = [
    data.aws_iam_policy_document.s3bucket_static_content.json
  ]

  public_access = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

data "aws_iam_policy_document" "s3bucket_static_content" {
  statement {
    sid    = "DontAllowNonSecureConnection"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      module.s3bucket_static_content.arn,
      "${module.s3bucket_static_content.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false",
      ]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "${module.s3bucket_static_content.arn}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        aws_cloudfront_distribution.main.arn
      ]
    }
  }

  # statement {
  #   sid    = "AllowManagedAccountsToList"
  #   effect = "Allow"

  #   actions = [
  #     "s3:ListBucket",
  #   ]

  #   resources = [
  #     module.s3bucket_static_content.arn,
  #   ]

  #   principals {
  #     type = "AWS"
  #     identifiers = [
  #       "arn:aws:iam::${var.aws_account_id}:root"
  #     ]
  #   }
  # }

  # statement {
  #   sid    = "AllowManagedAccountsToGet"
  #   effect = "Allow"

  #   actions = [
  #     "s3:GetObject",
  #   ]

  #   resources = [
  #     "${module.s3bucket_static_content.arn}/*",
  #   ]

  #   principals {
  #     type = "AWS"
  #     identifiers = [
  #       "arn:aws:iam::${var.aws_account_id}:root"
  #     ]
  #   }
  # }
}
