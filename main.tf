# ──────────────────────────────────────────────
# Provider Configuration
# ──────────────────────────────────────────────

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Project   = "s3-secure-bucket"
    }
  }
}

variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

# ──────────────────────────────────────────────
# Resource 1: The S3 Bucket
# ──────────────────────────────────────────────

resource "aws_s3_bucket" "secure" {
  # bucket or bucket_prefix — not both
  bucket = "secure-bucket-${var.bucket_name_suffix}"

  tags = {
    Name        = "secure-bucket-${var.bucket_name_suffix}"
    Environment = "learning"
  }

  # Lifecycle meta-argument: prevent accidental deletion
  lifecycle {
    prevent_destroy = false
  }
}

# ──────────────────────────────────────────────
# Resource 2: Block All Public Access
# ──────────────────────────────────────────────

resource "aws_s3_bucket_public_access_block" "secure" {
  bucket = aws_s3_bucket.secure.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ──────────────────────────────────────────────
# Resource 3: Enable Versioning
# ──────────────────────────────────────────────

resource "aws_s3_bucket_versioning" "secure" {
  bucket = aws_s3_bucket.secure.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ──────────────────────────────────────────────
# Resource 4: Server-Side Encryption (SSE-KMS)
# ──────────────────────────────────────────────

resource "aws_s3_bucket_server_side_encryption_configuration" "secure" {
  bucket = aws_s3_bucket.secure.id

  rule {
    apply_server_side_encryption_by_default {
      # Use the AWS-managed S3 key (alias: aws/s3)
      # Omitting kms_master_key_id selects this default key
      sse_algorithm = "aws:kms"
    }
    # Reuse a bucket-level key to reduce KMS API call costs
    bucket_key_enabled = true
  }
}