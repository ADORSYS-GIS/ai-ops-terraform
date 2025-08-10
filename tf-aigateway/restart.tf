# --- 7. Restart Envoy Gateway deployment ---
resource "null_resource" "restart_envoy_gateway" {
  provisioner "local-exec" {
    command = <<EOT
kubectl rollout restart -n ${var.envoy_gateway_namespace} deployment/envoy-gateway && \
kubectl wait --timeout=2m -n ${var.envoy_gateway_namespace} deployment/envoy-gateway --for=condition=Available
EOT
  }
  depends_on = [null_resource.envoy_gateway_rbac]
}