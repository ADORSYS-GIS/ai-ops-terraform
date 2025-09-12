terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    source  = "hashicorp/helm"
    version = ">= 2.9.0"
  }
}

resource "helm_release" "lmcache" {
  name             = var.release_name
  repository       = var.helm_repo
  chart            = var.helm_chart
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
