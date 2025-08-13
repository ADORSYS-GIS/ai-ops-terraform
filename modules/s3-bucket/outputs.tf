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
