output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "users" {
  description = "Information about all IAM users created for this bucket"
  value = {
    for k, v in aws_iam_user.bucket_users : k => {
      user_name     = v.name
      access_key_id = aws_iam_access_key.bucket_user_keys[k].id
      policy_arn    = aws_iam_policy.bucket_policies[k].arn
      permissions   = var.bucket_users[k].permissions
    }
  }
}

output "user_credentials" {
  description = "Sensitive credentials for all IAM users"
  value = {
    for k, v in aws_iam_access_key.bucket_user_keys : k => {
      user_name         = aws_iam_user.bucket_users[k].name
      access_key_id     = v.id
      secret_access_key = v.secret
    }
  }
  sensitive = true
}

output "kubernetes_secrets" {
  description = "Information about created Kubernetes secrets"
  value = {
    for k, v in kubernetes_secret.bucket_secrets : k => {
      secret_name = v.metadata[0].name
      namespace   = v.metadata[0].namespace
      user_key    = var.k8s_secrets[k].user_key
    }
  }
}
