## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.gateway_api](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kserve](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kserve_crd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.gateway](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.gatewayclass](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.kserve](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_install_cert_manager"></a> [install\_cert\_manager](#input\_install\_cert\_manager) | Install Cert Manager components | `bool` | `false` | no |
| <a name="input_install_gateway_api"></a> [install\_gateway\_api](#input\_install\_gateway\_api) | Install Gateway API components | `bool` | `false` | no |
| <a name="input_install_knative"></a> [install\_knative](#input\_install\_knative) | Install Knative components | `bool` | `false` | no |
| <a name="input_kserve_chart_version"></a> [kserve\_chart\_version](#input\_kserve\_chart\_version) | KServe Helm chart version | `string` | `"0.11.2"` | no |
| <a name="input_kserve_version"></a> [kserve\_version](#input\_kserve\_version) | n/a | `string` | `"v0.15.2"` | no |
| <a name="input_kube_ca_cert"></a> [kube\_ca\_cert](#input\_kube\_ca\_cert) | Kubernetes cluster CA certificate (raw PEM content) | `string` | n/a | yes |
| <a name="input_kube_client_cert"></a> [kube\_client\_cert](#input\_kube\_client\_cert) | Kubernetes client certificate (raw PEM content) | `string` | n/a | yes |
| <a name="input_kube_client_key"></a> [kube\_client\_key](#input\_kube\_client\_key) | Kubernetes client key (raw PEM content) | `string` | n/a | yes |
| <a name="input_kube_host"></a> [kube\_host](#input\_kube\_host) | Kubernetes API server endpoint (for k3s, typically https://localhost:6443) | `string` | `"https://localhost:6443"` | no |
| <a name="input_kube_token"></a> [kube\_token](#input\_kube\_token) | Kubernetes auth token (for k3s, can be found in /var/lib/rancher/k3s/server/token) | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace to install KServe into. | `string` | `"kserve"` | no |
| <a name="input_tls_certificate_name"></a> [tls\_certificate\_name](#input\_tls\_certificate\_name) | Name of the TLS certificate secret | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kserve_namespace"></a> [kserve\_namespace](#output\_kserve\_namespace) | n/a |
