terraform {
  required_version = ">= 1.5"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.31.0"
    }
  }
}

provider "kubernetes" {
  host                   = var.kube_host
  cluster_ca_certificate = base64decode(var.kube_cluster_ca_certificate)
  client_certificate     = base64decode(var.kube_client_certificate)
  client_key             = base64decode(var.kube_client_key)
  token                  = var.kube_token
}

provider "helm" {
  kubernetes = {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_cluster_ca_certificate)
    client_certificate     = base64decode(var.kube_client_certificate)
    client_key             = base64decode(var.kube_client_key)
    token                  = var.kube_token
  }
}