terraform {
  required_version = ">= 1.5.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.kube_host
    token                  = var.kube_token
    client_certificate     = var.kube_client_cert
    client_key             = var.kube_client_key
    cluster_ca_certificate = var.kube_ca_cert
  }
}
