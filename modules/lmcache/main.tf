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
      image_tag = var.image_tag
      storage_uri = var.storage_uri
    })
  ]
}
