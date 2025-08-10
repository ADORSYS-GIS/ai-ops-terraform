resource "helm_release" "ai_gateway" {
  name             = "aieg"
  repository       = var.helm_repository
  chart            = var.ai_gateway_chart
  version          = var.ai_gateway_version
  namespace        = var.ai_gateway_namespace
  create_namespace = true
  skip_crds        = true
  depends_on       = [helm_release.ai_gateway_crds]
}