terraform {
  required_version = ">= 1.5"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

locals {
  kubeconfig = {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_cluster_ca_certificate)
    token                  = var.kube_token
  }
}

provider "kubernetes" {
  host                   = local.kubeconfig.host
  cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
  token                  = local.kubeconfig.token
}

provider "helm" {
  kubernetes {
    host                   = local.kubeconfig.host
    cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
    token                  = local.kubeconfig.token
  }
}