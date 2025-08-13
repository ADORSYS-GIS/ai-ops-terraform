output "argocd_server_url" {
  value     = "https://${local.argocdDomain}"
  sensitive = false
}

output "s3_buckets" {
  description = "Information about created S3 buckets and their users"
  value = {
    for bucket_name, bucket_module in module.s3_buckets : bucket_name => {
      bucket_name = bucket_module.bucket_name
      bucket_arn  = bucket_module.bucket_arn
      users       = bucket_module.users
    }
  }
}

# Sensitive output for all credentials organized by bucket and user
output "s3_bucket_credentials" {
  description = "Sensitive credentials for all S3 bucket users"
  value = {
    for bucket_name, bucket_module in module.s3_buckets : bucket_name => {
      bucket_name = bucket_module.bucket_name
      users       = bucket_module.user_credentials
    }
  }
  sensitive = true
}
