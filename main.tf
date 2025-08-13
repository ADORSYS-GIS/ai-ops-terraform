provider "kubernetes" {
  config_path = var.kube_config_path
}

module "kserve" {
  source = "./tf-kserve"

  providers = {
    kubernetes = kubernetes
  }

  kube_host              = var.kube_host
  kube_token             = var.kube_token
  kube_ca_cert           = var.kube_ca_cert
  kube_client_cert       = var.kube_client_cert
  kube_client_key        = var.kube_client_key
  kserve_chart_version   = var.kserve_chart_version
  kserve_version         = var.kserve_version
  tls_certificate_name   = var.tls_certificate_name
  install_gateway_api    = var.install_gateway_api
  install_cert_manager   = var.install_cert_manager
  install_knative        = var.install_knative
}