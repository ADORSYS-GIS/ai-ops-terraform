terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

# This provider block has to be deleted before merging to the main branch
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"  # Update path if needed
  }
}

