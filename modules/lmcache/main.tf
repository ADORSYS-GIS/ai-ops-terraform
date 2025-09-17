resource "helm_release" "lmcache_kserve_inference" {
  name       = var.release_name
  namespace  = var.namespace
  
  # Use chart from GitHub repository
  repository = "https://github.com/ADORSYS-GIS/ai-helm"
  chart      = "charts/lmcache-kserve-inference"
  
  values = [
    templatefile("${path.module}/values.yaml", {
      image_tag = var.image_tag
      storage_uri = var.storage_uri
    })
  ]
}
