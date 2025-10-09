resource "helm_release" "lmcache" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "https://adorsys-gis.github.io/ai-helm"
  chart      = "lmcache"
  version    = var.chart_version

  wait             = true
  timeout          = 600
  create_namespace = true

  set {
    name  = "controllers.main.replicas"
    value = tostring(var.replica_count)
  }

}
