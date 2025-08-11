## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.12.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.12.1 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.ai_gateway](https://registry.terraform.io/providers/hashicorp/helm/2.12.1/docs/resources/release) | resource |
| [helm_release.ai_gateway_crds](https://registry.terraform.io/providers/hashicorp/helm/2.12.1/docs/resources/release) | resource |
| [helm_release.envoy_gateway](https://registry.terraform.io/providers/hashicorp/helm/2.12.1/docs/resources/release) | resource |
| [kubectl_manifest.envoy_gateway_config](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.envoy_gateway_rbac](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.redis_deployment](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.redis_namespace](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.redis_service](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [http_http.config_yaml](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.rbac_yaml](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_gateway_namespace"></a> [ai\_gateway\_namespace](#input\_ai\_gateway\_namespace) | Namespace for AI Gateway components | `string` | `"envoy-ai-gateway-system"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the Helm charts | `string` | `"v0.0.0-latest"` | no |
| <a name="input_config_yaml_url"></a> [config\_yaml\_url](#input\_config\_yaml\_url) | URL for the Envoy Gateway config YAML | `string` | `"https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/config.yaml"` | no |
| <a name="input_envoy_gateway_namespace"></a> [envoy\_gateway\_namespace](#input\_envoy\_gateway\_namespace) | Namespace for Envoy Gateway | `string` | `"envoy-gateway-system"` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | Path to the kubeconfig file | `string` | `"~/.kube/config"` | no |
| <a name="input_rbac_yaml_url"></a> [rbac\_yaml\_url](#input\_rbac\_yaml\_url) | URL for the Envoy Gateway RBAC YAML | `string` | `"https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/rbac.yaml"` | no |
| <a name="input_redis_namespace"></a> [redis\_namespace](#input\_redis\_namespace) | Namespace for Redis (note: this is referenced in YAML manifests; changing it may require updating the YAML content) | `string` | `"redis-system"` | no |
| <a name="input_redis_yaml_url"></a> [redis\_yaml\_url](#input\_redis\_yaml\_url) | URL for the Redis YAML manifest | `string` | `"https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/redis.yaml"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ai_gateway_namespace"></a> [ai\_gateway\_namespace](#output\_ai\_gateway\_namespace) | Namespace where AI Gateway is installed |
| <a name="output_envoy_gateway_namespace"></a> [envoy\_gateway\_namespace](#output\_envoy\_gateway\_namespace) | Namespace where Envoy Gateway is installed |
| <a name="output_redis_namespace"></a> [redis\_namespace](#output\_redis\_namespace) | Namespace where Redis is installed |
