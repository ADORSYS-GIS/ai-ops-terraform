variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "bucket_config" {
  description = "Configuration for the S3 bucket"
  type = object({
    versioning_enabled = optional(bool, false)
    encryption_type    = optional(string, "AES256")
  })
  default = {}
}

variable "bucket_users" {
  description = "Map of IAM users to create for this bucket"
  type = map(object({
    permissions = list(string) # ["read", "write", "delete"]
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
