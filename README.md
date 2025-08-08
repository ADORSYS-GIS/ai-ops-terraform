## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kserve"></a> [kserve](#module\_kserve) | ./tf-kserve | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_install_cert_manager"></a> [install\_cert\_manager](#input\_install\_cert\_manager) | Install Cert Manager components | `bool` | `false` | no |
| <a name="input_install_gateway_api"></a> [install\_gateway\_api](#input\_install\_gateway\_api) | Install Gateway API components | `bool` | `false` | no |
| <a name="input_install_knative"></a> [install\_knative](#input\_install\_knative) | Install Knative components | `bool` | `false` | no |
| <a name="input_kserve_chart_version"></a> [kserve\_chart\_version](#input\_kserve\_chart\_version) | KServe Helm chart version | `string` | `"0.11.2"` | no |
| <a name="input_kserve_version"></a> [kserve\_version](#input\_kserve\_version) | n/a | `string` | `"v0.15.2"` | no |
| <a name="input_kube_ca_cert"></a> [kube\_ca\_cert](#input\_kube\_ca\_cert) | Kubernetes cluster CA certificate | `string` | n/a | yes |
| <a name="input_kube_client_cert"></a> [kube\_client\_cert](#input\_kube\_client\_cert) | Kubernetes client certificate | `string` | n/a | yes |
| <a name="input_kube_client_key"></a> [kube\_client\_key](#input\_kube\_client\_key) | Kubernetes client key | `string` | n/a | yes |
| <a name="input_kube_host"></a> [kube\_host](#input\_kube\_host) | Kubernetes API server endpoint | `string` | n/a | yes |
| <a name="input_kube_token"></a> [kube\_token](#input\_kube\_token) | Kubernetes auth token | `string` | n/a | yes |
| <a name="input_tls_certificate_name"></a> [tls\_certificate\_name](#input\_tls\_certificate\_name) | Name of the TLS certificate secret | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kserve_namespace"></a> [kserve\_namespace](#output\_kserve\_namespace) | n/a |
