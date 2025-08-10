# --- 5. Apply Envoy Gateway Config (ignore missing annotations warning) ---
resource "null_resource" "envoy_gateway_config" {
  provisioner "local-exec" {
    command = "kubectl apply --force -f https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/config.yaml || true"
  }
  depends_on = [null_resource.redis_config]
}