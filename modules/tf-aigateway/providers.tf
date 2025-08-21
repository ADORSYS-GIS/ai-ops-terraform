locals {
  kubeconfig = {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_cluster_ca_certificate)
    client_certificate     = base64decode(var.kube_client_certificate)
    client_key             = base64decode(var.kube_client_key)
    token                  = var.kube_token
  }
}

provider "kubernetes" {
  host                   = local.kubeconfig.host
  cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
  client_certificate     = local.kubeconfig.client_certificate
  client_key             = local.kubeconfig.client_key
  token                  = local.kubeconfig.token
}

provider "helm" {
  kubernetes = {
    host                   = local.kubeconfig.host
    cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
    client_certificate     = local.kubeconfig.client_certificate
    client_key             = local.kubeconfig.client_key
    token                  = local.kubeconfig.token
  }
}