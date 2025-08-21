# S3 Multi-User Terraform Module

Terraform module for creating S3 buckets with multiple IAM users and automatic Kubernetes secret injection.

## Features

- Multiple IAM users per S3 bucket with granular permissions
- Automatic Kubernetes secret creation for EKS integration
- Support for versioning, encryption, and custom tagging

## Quick Start

1. **Setup**

   ```bash
   cp prod.tfvars.example prod.tfvars
   # Edit prod.tfvars with your configuration
   ```

2. **Deploy**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration

Create `prod.tfvars` (not committed to git) with your bucket configuration:

### Web Bucket example from the secret.tf file

```hcl
s3_buckets = {
  "web" = {
    enabled            = true
    versioning_enabled = true
    encryption_type    = "KMS"
    users = {
      "web-user" = {
        permissions = ["read", "write", "delete", "list"]
      }

    }
    k8s_secrets = {
      "open-web-ui-secret" = {
        namespace   = "chat-ui"
        secret_name = "open-web-ui-s3"
        user_key    = "web-user"
        extra_data = {
          STORAGE_PROVIDER = "s3"
          S3_REGION_NAME   = "us-east-1"
        }
      }
    }
  }
}
```

## Permissions

| Permission | Actions                       | Description       |
| ---------- | ----------------------------- | ----------------- |
| `read`     | GetObject, ListBucket         | Download and list |
| `write`    | PutObject                     | Upload            |
| `delete`   | DeleteObject                  | Delete objects    |
| `list`     | ListBucket, GetBucketLocation | List contents     |

## Outputs

```bash
# View created resources
terraform output s3_buckets

# Get credentials (sensitive)
terraform output s3_bucket_credentials

# Specific bucket info
terraform output -json s3_buckets | jq '.web'
```

## Kubernetes Integration

Secrets are automatically created in specified namespaces:

```yaml
# Generated secret structure
apiVersion: v1
kind: Secret
metadata:
  name: open-web-ui-s3
  namespace: chat-ui
data:
  S3_BUCKET_NAME: <base64>
  S3_ACCESS_KEY_ID: <base64>
  S3_SECRET_ACCESS_KEY: <base64>
  STORAGE_PROVIDER: <base64>
  S3_REGION_NAME: <base64>
```

3. **Destroy**

```bash
terraform destroy
```
