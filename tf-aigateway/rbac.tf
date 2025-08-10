# --- 6. Apply RBAC rules ---
resource "null_resource" "envoy_gateway_rbac" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/rbac.yaml"
  }
  depends_on = [null_resource.envoy_gateway_config]
}