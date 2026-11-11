variable "bucket_name_suffix" {
  description = "A unique suffix appended to the bucket name. Bucket names must be globally unique across all of AWS."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.bucket_name_suffix))
    error_message = "The suffix must contain at least one character and may only include lowercase letters, digits, and hyphens."
  }
}