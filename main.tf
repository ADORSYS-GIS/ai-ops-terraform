terraform {
  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

module "kserve" {
  source = "./modules/tf-kserve"

  kserve_version                = var.kserve_version
  eks_cluster_oidc_issuer_url   = module.eks.cluster_oidc_issuer_url
}

module "ai-gateway" {
  source = "./modules/tf-aigateway"
}