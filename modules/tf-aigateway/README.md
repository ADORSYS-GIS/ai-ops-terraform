## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.31.0 |

## Providers

- Helm
- Kubernetes

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ai_gateway"></a> [ai\_gateway](#module\_ai\_gateway) | terraform-module/release/helm | >= 2.9.1 |
| <a name="module_envoy_gateway"></a> [envoy\_gateway](#module\_envoy\_gateway) | terraform-module/release/helm | >= 2.9.1 |
| <a name="module_redis"></a> [redis](#module\_redis) | terraform-module/release/helm | >= 2.9.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_gateway_namespace"></a> [ai\_gateway\_namespace](#input\_ai\_gateway\_namespace) | Namespace for AI Gateway components | `string` | `"envoy-ai-gateway-system"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the Helm charts | `string` | `"v0.0.0-latest"` | no |
| <a name="input_enable_redis"></a> [enable\_redis](#input\_enable\_redis) | Whether to deploy the Redis Helm chart | `bool` | n/a | yes |
| <a name="input_envoy_gateway_namespace"></a> [envoy\_gateway\_namespace](#input\_envoy\_gateway\_namespace) | Namespace for Envoy Gateway | `string` | `"envoy-gateway-system"` | no |
| <a name="input_kube_client_certificate"></a> [kube\_client\_certificate](#input\_kube\_client\_certificate) | client certificate | `string` | n/a | yes |
| <a name="input_kube_client_key"></a> [kube\_client\_key](#input\_kube\_client\_key) | Input the Client key | `string` | n/a | yes |
| <a name="input_kube_cluster_ca_certificate"></a> [kube\_cluster\_ca\_certificate](#input\_kube\_cluster\_ca\_certificate) | Client cluster ca certificate | `string` | n/a | yes |
| <a name="input_kube_host"></a> [kube\_host](#input\_kube\_host) | API server endpoint link | `string` | n/a | yes |
| <a name="input_kube_token"></a> [kube\_token](#input\_kube\_token) | Path to the kubeconfig file | `string` | n/a | yes |
| <a name="input_redis_namespace"></a> [redis\_namespace](#input\_redis\_namespace) | Namespace for Redis (note: this is referenced in YAML manifests; changing it may require updating the YAML content) | `string` | `"redis-system"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ai_gateway_namespace"></a> [ai\_gateway\_namespace](#output\_ai\_gateway\_namespace) | Namespace where AI Gateway is installed |
| <a name="output_envoy_gateway_namespace"></a> [envoy\_gateway\_namespace](#output\_envoy\_gateway\_namespace) | Namespace where Envoy Gateway is installed |
| <a name="output_redis_namespace"></a> [redis\_namespace](#output\_redis\_namespace) | Namespace where Redis is installed |
