# --- 4. Apply Redis deployment ---
resource "null_resource" "redis_config" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/redis.yaml"
  }
  depends_on = [helm_release.envoy_gateway]
}