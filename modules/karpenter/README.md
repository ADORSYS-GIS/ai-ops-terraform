# Karpenter Terraform Module

This module deploys Karpenter to an EKS cluster.

## Usage

```hcl
module "karpenter" {
  source = "./modules/karpenter"

  cluster_name        = "my-eks-cluster"
  cluster_endpoint    = "https://XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.gr7.us-east-1.eks.amazonaws.com"
  node_iam_role_arn   = "arn:aws:iam::XXXXXXXXXXXX:role/eks-node-role"
  instance_profile    = "eks-node-instance-profile"
  custom_ami_id       = "ami-XXXXXXXXXXXXXXXXX"
  namespace           = "karpenter"
  create_namespace    = true
  chart_version       = "1.4.0"
  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | The name of the EKS cluster. | `string` | n/a | yes |
| cluster\_endpoint | The endpoint for your EKS cluster's API server. | `string` | n/a | yes |
| node\_iam\_role\_arn | The ARN of the IAM role for the Karpenter nodes. | `string` | n/a | yes |
| instance\_profile | The instance profile for the Karpenter nodes. | `string` | n/a | yes |
| custom\_ami\_id | The ID of a custom AMI to use for Karpenter nodes. If empty, Karpenter will use the default. | `string` | `""` | no |
| namespace | The Kubernetes namespace in which to install Karpenter. | `string` | `"karpenter"` | no |
| create\_namespace | Whether to create the namespace if it does not exist. | `bool` | `true` | no |
| chart\_version | The version of the Karpenter Helm chart to install. | `string` | `"1.4.0"` | no |
| tags | A map of tags to apply to the resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| interruption\_queue\_name | The name of the SQS queue created for interruption handling. |
| pod\_identity\_association\_arn | The ARN of the Pod Identity Association. |