resource "helm_release" "lmcache_kserve_inference" {
  name       = var.release_name
  namespace  = var.namespace
  
  # Specify the path to your local Helm chart
  chart      = "${path.module}/lmcache-kserve-inference"
  
  values = [
    templatefile("${path.module}/values.yaml", {
      image_tag = var.image_tag
      storage_uri = var.storage_uri
    })
  ]
}

