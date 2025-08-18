## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.31.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_argocd"></a> [argocd](#module\_argocd) | terraform-module/release/helm | >=2.9.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kube_client_certificate"></a> [kube\_client\_certificate](#input\_kube\_client\_certificate) | n/a | `string` | n/a | yes |
| <a name="input_kube_client_key"></a> [kube\_client\_key](#input\_kube\_client\_key) | n/a | `string` | n/a | yes |
| <a name="input_kube_cluster_ca_certificate"></a> [kube\_cluster\_ca\_certificate](#input\_kube\_cluster\_ca\_certificate) | n/a | `string` | n/a | yes |
| <a name="input_kube_host"></a> [kube\_host](#input\_kube\_host) | n/a | `string` | n/a | yes |
| <a name="input_kube_token"></a> [kube\_token](#input\_kube\_token) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
