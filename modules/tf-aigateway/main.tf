terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0"
    }
  }
}

module "envoy_gateway" {
   source  = "terraform-module/release/helm"
   version = "2.8.2"

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

   values = []

   depends_on = []
 }


module "ai_gateway_crds" {
   source  = "terraform-module/release/helm"
   version = "2.8.2"

   repository = "oci://docker.io/envoyproxy"
   namespace  = var.ai_gateway_namespace

   app = {
     name    = "aieg-crd"
     chart   = "ai-gateway-crds-helm"
     version = var.chart_version
     deploy  = 1
     create_namespace = true
     wait    = true
   }

   set = []

   values = []

   depends_on = [module.envoy_gateway]
}

module "ai_gateway" {
   source  = "terraform-module/release/helm"
   version = "2.8.2"

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

   depends_on = [module.envoy_gateway, module.ai_gateway_crds]
 }

module "redis" {
   count = var.enable_redis ? 1 : 0

   source = "terraform-module/release/helm"
   version = "2.8.2"

   repository = var.enable_redis ? "https://charts.bitnami.com/bitnami" : null
   namespace  = var.enable_redis ? var.redis_namespace : null

   app = {
     name       = "redis"
     chart      = "redis"
     version    = "19.0.1"
     deploy     = 1
     create_namespace = true
   }

   values = var.enable_redis ? [] : null 

   depends_on = [module.envoy_gateway, module.ai_gateway]
}