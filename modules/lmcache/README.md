# LMCache Terraform Module

This Terraform module deploys the LMCache application using a Helm chart.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.lmcache](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the Helm chart to deploy | `string` | `"0.1.0"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The image tag for the LMCache. | `string` | `"v0.3.6"` | no |
| <a name="input_lmcache_settings"></a> [lmcache\_settings](#input\_lmcache\_settings) | Configuration for the LMCache. | <pre>object({<br>    chunkSize      = string<br>    localCpu       = string<br>    localDisk      = string<br>    maxLocalDiskSize = string<br>    remoteUrl      = string<br>    enableP2P      = string<br>    lookupUrl      = optional(string)<br>    distributedUrl = optional(string)<br>  })</pre> | <pre>{
  "chunkSize": "512",
  "distributedUrl": null,
  "enableP2P": "False",
  "localCpu": "True",
  "localDisk": "file:///tmp/lmcache",
  "lookupUrl": null,
  "maxLocalDiskSize": "10.0",
  "remoteUrl": ""
}</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the LMCache into. | `string` | `"lmcache"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | Node selector for pod placement (e.g., for GPU nodes) | `map(string)` | <pre>{"node.kubernetes.io/instance-type":"g4dn.xlarge"}</pre> | no |
| <a name="input_redis_auth_token"></a> [redis\_auth\_token](#input\_redis\_auth\_token) | Redis authentication token for LMCache | `string` | `""` | no |
| <a name="input_redis_host"></a> [redis\_host](#input\_redis\_host) | Redis host for LMCache remote storage | `string` | `""` | no |
| <a name="input_redis_port"></a> [redis\_port](#input\_redis\_port) | Redis port for LMCache remote storage | `number` | `6379` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the Helm release. | `string` | `"lmcache"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | The number of replicas for the LMCache. | `number` | `2` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | The compute resources for the LMCache. | <pre>object({<br>    requests = object({<br>      memory = string<br>      cpu    = string<br>      gpu    = string<br>    })<br>    limits = object({<br>      memory = string<br>      cpu    = string<br>      gpu    = string<br>    })<br>  })</pre> | <pre>{"limits":{"cpu":"8000m","gpu":"1","memory":"16Gi"},"requests":{"cpu":"4000m","gpu":"1","memory":"8Gi"}}</pre> | no |
| <a name="input_storage_uri"></a> [storage\_uri](#input\_storage\_uri) | The storage URI for the LLM model. Can be S3, Redis, or other supported protocols. | `string` | `""` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Tolerations for pod scheduling | <pre>list(object({<br>    key      = string<br>    operator = string<br>    value    = string<br>    effect   = string<br>  }))</pre> | <pre>[<br>  {<br>    "effect": "NoSchedule",<br>    "key": "nvidia.com/gpu",<br>    "operator": "Equal",<br>    "value": "true"<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chart_version"></a> [chart\_version](#output\_chart\_version) | The version of the deployed Helm chart |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where the release is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | The name of the deployed Helm release |
| <a name="output_status"></a> [status](#output\_status) | The status of the Helm release |