## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.lmcache](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version | `string` | `"0.1.4"` | no |
| <a name="input_helm_chart"></a> [helm\_chart](#input\_helm\_chart) | Helm chart name for lmcache | `string` | `"vllm-stack"` | no |
| <a name="input_helm_repo"></a> [helm\_repo](#input\_helm\_repo) | Helm chart repository URL for lmcache | `string` | `"https://vllm-project.github.io/production-stack"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where lmcache will be installed | `string` | `"vllm-lmcache"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"vllm-stack-lmcache"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lmcache_namespace"></a> [lmcache\_namespace](#output\_lmcache\_namespace) | Namespace where lmcache is deployed |
| <a name="output_lmcache_release"></a> [lmcache\_release](#output\_lmcache\_release) | Helm release name |
| <a name="output_lmcache_status"></a> [lmcache\_status](#output\_lmcache\_status) | Helm release status |
