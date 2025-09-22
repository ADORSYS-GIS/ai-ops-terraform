locals {
  # Construct Redis URL with authentication if provided
  redis_url = var.redis_host != "" ? (
    var.redis_auth_token != "" ? 
    "redis://:${var.redis_auth_token}@${var.redis_host}:${var.redis_port}" :
    "redis://${var.redis_host}:${var.redis_port}"
  ) : ""
  
  # Use provided storage_uri or construct Redis URL
  effective_storage_uri = var.storage_uri != "" ? var.storage_uri : (
    local.redis_url != "" ? "${local.redis_url}/models" : ""
  )
  
  # Merge lmcache settings with dynamic Redis URL
  effective_lmcache_settings = merge(var.lmcache_settings, {
    remoteUrl = local.redis_url
  })
  
  # Construct the ingress configuration dynamically
  ingress_config = var.ingress.enabled && var.ingress_host != "" ? {
    enabled = true
    hosts = [{
      host  = var.ingress_host
      paths = [{ path = "/", pathType = "Prefix" }]
    }]
    tls = [{
      secretName = "${var.ingress_host}-tls"
      hosts      = [var.ingress_host]
    }]
    } : {
    enabled = false
    hosts   = []
    tls     = []
  }
}

resource "helm_release" "lmcache_kserve_inference" {
  name       = var.release_name
  namespace  = var.namespace
  
  # Use proper Helm repository (GitHub Pages)
  repository = "https://adorsys-gis.github.io/ai-helm"
  chart      = "lmcache-kserve-inference"
  version    = var.chart_version
  
  # Production settings
  wait             = true
  timeout          = 600
  create_namespace = true
  
  values = [
    templatefile("${path.module}/values.yaml", {
      image_tag        = var.image_tag
      storage_uri      = local.effective_storage_uri
      replica_count    = var.replica_count
      resources        = var.resources
      lmcache          = local.effective_lmcache_settings
      ingress          = local.ingress_config
    })
  ]
}
