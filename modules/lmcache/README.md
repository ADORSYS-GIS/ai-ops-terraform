## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.lmcache_kserve_inference](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The image tag for the LMCache-enabled vLLM predictor. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the InferenceService into. | `string` | `"default"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the Helm release. | `string` | `"lmcache-inference"` | no |
| <a name="input_storage_uri"></a> [storage\_uri](#input\_storage\_uri) | The storage URI for the LLM model | `string` | `""` | no |

## Outputs

No outputs.
