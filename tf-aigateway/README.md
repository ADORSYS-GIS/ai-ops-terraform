# Terraform AI Gateway Module

This Terraform module installs and configures the AI Gateway and Envoy Gateway on a Kubernetes cluster using Helm charts.

## Overview

This module automates the deployment of:
1. AI Gateway CRDs
2. AI Gateway
3. Envoy Gateway
4. Redis deployment
5. Envoy Gateway configuration
6. RBAC rules
7. Envoy Gateway restart

## Prerequisites

- Kubernetes cluster
- Helm CLI installed
- kubectl configured to access your cluster
- Terraform 0.13+

## Module Usage

```hcl
module "ai_gateway" {
  source = "./tf-aigateway"

  # Optional variables (defaults shown)
  helm_repository      = "oci://docker.io/envoyproxy"
  crd_chart            = "ai-gateway-crds-helm"
  ai_gateway_chart     = "ai-gateway-helm"
  envoy_gateway_chart  = "gateway-helm"
  crd_version          = "v0.0.0-latest"
  ai_gateway_version   = "v0.0.0-latest"
  envoy_gateway_version = "v0.0.0-latest"
  ai_gateway_namespace = "envoy-ai-gateway-system"
  envoy_gateway_namespace = "envoy-gateway-system"
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| helm_repository | The Helm repository to use | string | `oci://docker.io/envoyproxy` | no |
| crd_chart | The CRD Helm chart name | string | `ai-gateway-crds-helm` | no |
| ai_gateway_chart | The AI Gateway Helm chart name | string | `ai-gateway-helm` | no |
| envoy_gateway_chart | The Envoy Gateway Helm chart name | string | `gateway-helm` | no |
| crd_version | The version of the CRD chart | string | `v0.0.0-latest` | no |
| ai_gateway_version | The version of the AI Gateway chart | string | `v0.0.0-latest` | no |
| envoy_gateway_version | The version of the Envoy Gateway chart | string | `v0.0.0-latest` | no |
| ai_gateway_namespace | The namespace for AI Gateway | string | `envoy-ai-gateway-system` | no |
| envoy_gateway_namespace | The namespace for Envoy Gateway | string | `envoy-gateway-system` | no |

## Outputs

| Name | Description |
|------|-------------|
| ai_gateway_namespace | The namespace where AI Gateway is installed |
| envoy_gateway_namespace | The namespace where Envoy Gateway is installed |
| ai_gateway_release_name | The name of the AI Gateway Helm release |
| envoy_gateway_release_name | The name of the Envoy Gateway Helm release |

## Notes

- This module requires Helm and kubectl to be installed and configured
- The module uses null_resource for applying Kubernetes manifests and restarting deployments
- All resources are created in the specified namespaces
- The module handles dependencies between resources using `depends_on`

## Testing

To test this module in a real environment:

1. Ensure you have a working Kubernetes cluster with Helm and kubectl configured
2. Create a Terraform configuration file (e.g., `main.tf`) with:
```hcl
module "ai_gateway" {
  source = "./tf-aigateway"
}
```
3. Run the following commands:
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

## License

MIT