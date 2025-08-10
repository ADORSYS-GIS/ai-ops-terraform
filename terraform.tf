terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
  }
}

module "envoy_ai_gateway" {
  source = "./tf-aigateway"
  
  kubeconfig = var.kubeconfig
}