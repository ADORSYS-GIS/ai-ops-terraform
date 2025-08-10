output "ai_gateway_namespace" {
  description = "The namespace where AI Gateway is installed"
  value       = var.ai_gateway_namespace
}

output "envoy_gateway_namespace" {
  description = "The namespace where Envoy Gateway is installed"
  value       = var.envoy_gateway_namespace
}

output "ai_gateway_release_name" {
  description = "The name of the AI Gateway Helm release"
  value       = helm_release.ai_gateway.name
}

output "envoy_gateway_release_name" {
  description = "The name of the Envoy Gateway Helm release"
  value       = helm_release.envoy_gateway.name
}