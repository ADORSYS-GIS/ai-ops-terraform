# --- 3. Install Envoy Gateway ---
resource "helm_release" "envoy_gateway" {
  name             = "eg"
  repository       = var.helm_repository
  chart            = var.envoy_gateway_chart
  version          = var.envoy_gateway_version
  namespace        = var.envoy_gateway_namespace
  create_namespace = true
  depends_on       = [helm_release.ai_gateway]
}