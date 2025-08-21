# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.bucket_config.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.bucket_config.encryption_type == "KMS" ? "aws:kms" : "AES256"
    }
  }
}

# IAM Users for this bucket (one per user defined)
resource "aws_iam_user" "bucket_users" {
  for_each = var.bucket_users

  name = "${var.bucket_name}-${each.key}"
  tags = merge(var.tags, {
    BucketName = var.bucket_name
    UserRole   = each.key
  })
}

# IAM Access Keys (one per user)
resource "aws_iam_access_key" "bucket_user_keys" {
  for_each = var.bucket_users

  user = aws_iam_user.bucket_users[each.key].name
}

# IAM Policy Documents (one per user, customized based on their permissions)
data "aws_iam_policy_document" "bucket_policies" {
  for_each = var.bucket_users

  # Read permissions
  dynamic "statement" {
    for_each = contains(each.value.permissions, "read") ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      resources = [
        aws_s3_bucket.bucket.arn,
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  }

  # Write permissions
  dynamic "statement" {
    for_each = contains(each.value.permissions, "write") ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "s3:PutObject"
      ]
      resources = [
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  }

  # Delete permissions
  dynamic "statement" {
    for_each = contains(each.value.permissions, "delete") ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "s3:DeleteObject"
      ]
      resources = [
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  }

  # List bucket contents (useful for management operations)
  dynamic "statement" {
    for_each = contains(each.value.permissions, "list") ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ]
      resources = [
        aws_s3_bucket.bucket.arn
      ]
    }
  }
}

# IAM Policies (one per user)
resource "aws_iam_policy" "bucket_policies" {
  for_each = var.bucket_users

  name        = "${var.bucket_name}-${each.key}-policy"
  description = "Policy for ${each.key} access to ${var.bucket_name} bucket"
  policy      = data.aws_iam_policy_document.bucket_policies[each.key].json
  tags        = var.tags
}

# Attach policies to users
resource "aws_iam_user_policy_attachment" "bucket_user_policies" {
  for_each = var.bucket_users

  user       = aws_iam_user.bucket_users[each.key].name
  policy_arn = aws_iam_policy.bucket_policies[each.key].arn
}

# Kubernetes Secrets for EKS injection
resource "kubernetes_secret" "bucket_secrets" {
  for_each = var.k8s_secrets

  metadata {
    name      = each.value.secret_name
    namespace = each.value.namespace
  }

  data = merge(
    {
      S3_BUCKET_NAME       = aws_s3_bucket.bucket.bucket
      S3_ACCESS_KEY_ID     = aws_iam_access_key.bucket_user_keys[each.value.user_key].id
      S3_SECRET_ACCESS_KEY = aws_iam_access_key.bucket_user_keys[each.value.user_key].secret
    },
    each.value.extra_data
  )

  type = "Opaque"
}
