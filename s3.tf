# Create S3 buckets using the module
module "s3_buckets" {
  source = "./modules/s3-bucket"

  for_each = { for k, v in var.s3_buckets : k => v if v.enabled }

  bucket_name = "${local.name}-${each.key}"
  bucket_config = {
    versioning_enabled = each.value.versioning_enabled
    encryption_type    = each.value.encryption_type
  }
  bucket_users = each.value.users

  tags = merge(
    local.tags,
    {
      Name        = "${local.name}-${each.key}"
      Environment = var.environment
      Purpose     = each.key
    }
  )
}
