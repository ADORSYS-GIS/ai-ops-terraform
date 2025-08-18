terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.31.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  host                    = var.kube_host
  cluster_ca_certificate  = base64decode(var.kube_cluster_ca_certificate)
  client_certificate      = base64decode(var.kube_client_certificate)
  client_key              = base64decode(var.kube_client_key)
  token                   = var.kube_token
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

 module "ai_gateway_crds" {
    source  = "terraform-module/release/helm"
    version = ">= 2.9.1"

    repository = "oci://docker.io/envoyproxy"
    namespace  = var.ai_gateway_namespace

    app = {
      name    = "aieg-crd"
      version = var.chart_version
      chart   = "ai-gateway-crds-helm"
      create_namespace = true
      deploy = 1

    }

    set = []

    values = []

    depends_on = []
  }

module "envoy_gateway" {
   source  = "terraform-module/release/helm"
   version = ">= 2.9.1"

   repository = "oci://docker.io/envoyproxy"
   namespace  = var.envoy_gateway_namespace

   app = {
     name    = "eg"
     version = var.chart_version
     chart   = "gateway-helm"
     deploy = 1
     create_namespace = true
   }

   set = []

   values = [file("./values/config.yaml")]

   depends_on = [module.ai_gateway_crds]
 }

module "ai_gateway" {
   source  = "terraform-module/release/helm"
   version = ">= 2.9.1"

   repository = "oci://docker.io/envoyproxy"
   namespace  = var.ai_gateway_namespace

   app = {
     name    = "aieg"
     version = var.chart_version
     chart   = "ai-gateway-helm"
     deploy = 1
     create_namespace = true
     wait    = false
   }

   set = []

   values = []

   depends_on = [module.ai_gateway_crds, module.envoy_gateway]
 }

module "redis" {
   source = "terraform-module/release/helm"
   version = ">= 2.9.1"

   repository = "https://charts.bitnami.com/bitnami"
   namespace  = var.redis_namespace

   app = {
     name       = "redis"
     chart      = "redis"
     version    = "19.0.1"
     deploy     = 1
     create_namespace = true
   }

   values = []

   depends_on = [module.envoy_gateway, module.ai_gateway, module.ai_gateway_crds]
 }


module "envoy_gateway_config" {
   source  = "terraform-module/release/helm"
   version = ">= 2.9.1"

   repository = ""
   namespace  = var.envoy_gateway_namespace

   app = {
     name    = "envoy-gateway-config"
     version = "0.1.0"
     chart   = "./charts/envoy-gateway-config"
     deploy  = 1
     # force_update     = true
   }

   values = []

   depends_on = [module.ai_gateway_crds, module.envoy_gateway, module.ai_gateway, module.ai_gateway_crds]
 }
