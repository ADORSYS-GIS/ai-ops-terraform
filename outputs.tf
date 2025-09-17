output "argocd_server_url" {
  value     = "https://${local.argocdDomain}"
  sensitive = false

}

output "kserve_namespace" {
  value = module.kserve.kserve_namespace
}

# AI Gateway module outputs
output "ai_gateway_namespace" {
  value = module.ai_gateway.ai_gateway_namespace
}

output "envoy_gateway_namespace" {
  value = module.ai_gateway.envoy_gateway_namespace
}

output "redis_namespace" {
  value = module.ai_gateway.redis_namespace
}

# Output all bucket information as a nested dictionary
output "s3_buckets" {
  description = "Information about created S3 buckets, users, and Kubernetes secrets"
  value = {
    for bucket_name, bucket_module in module.s3_buckets : bucket_name => {
      bucket_name        = bucket_module.bucket_name
      bucket_arn         = bucket_module.bucket_arn
      users              = bucket_module.users
      kubernetes_secrets = bucket_module.kubernetes_secrets
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
