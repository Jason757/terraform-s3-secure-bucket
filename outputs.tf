output "bucket_id" {
  description = "The name (ID) of the S3 bucket."
  value       = aws_s3_bucket.secure.id
}

output "bucket_arn" {
  description = "The Amazon Resource Name (ARN) of the S3 bucket."
  value       = aws_s3_bucket.secure.arn
}

output "bucket_region" {
  description = "The AWS region the bucket resides in."
  value       = aws_s3_bucket.secure.region
}