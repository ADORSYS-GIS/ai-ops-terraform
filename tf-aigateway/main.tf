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

   depends_on = []
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

   depends_on = [module.envoy_gateway]
 }

module "redis" {
   count = var.enable_redis ? 1 : 0

   source = "terraform-module/release/helm"
   version = ">= 2.9.1"

   repository = var.redis_enabled ? "https://charts.bitnami.com/bitnami" : null
   namespace  = var.redis_enabled ? var.redis_namespace : null

   app = {
     name       = "redis"
     chart      = "redis"
     version    = "19.0.1"
     deploy     = 1
     create_namespace = true
   }

   values = var.redis_enabled ? [] : null 

   depends_on = var.redis_enabled ? [module.envoy_gateway, module.ai_gateway] : []
}