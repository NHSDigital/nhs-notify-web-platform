resource "aws_s3_bucket" "static_assets" {
  bucket        = "${local.csi_global}-static"
  force_destroy = "true"
}

resource "aws_s3_bucket_cors_configuration" "static_assets" {
  bucket = aws_s3_bucket.static_assets.bucket

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 300
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_assets" {
  bucket = aws_s3_bucket.static_assets.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "static_assets" {
  depends_on = [
    aws_s3_bucket.static_assets,
    aws_s3_bucket_policy.static_assets
  ]

  bucket = aws_s3_bucket.static_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  target_bucket = var.bucket_logging_bucket
  target_prefix = "static_assets/${aws_s3_bucket.static_assets.bucket}/"
}

resource "aws_s3_bucket_lifecycle_configuration" "static_assets" {
  bucket                = aws_s3_bucket.static_assets.id
  expected_bucket_owner = local.this_account

  rule {
    id     = "default"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = "30"
    }
  }
}
