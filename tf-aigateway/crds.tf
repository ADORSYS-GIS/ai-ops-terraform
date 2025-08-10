# --- 1. Install AI Gateway CRDs ---
resource "helm_release" "ai_gateway_crds" {
  name             = "aieg-crd"
  repository       = var.helm_repository
  chart            = var.crd_chart
  version          = var.crd_version
  namespace        = var.ai_gateway_namespace
  create_namespace = true
}