output "ai_gateway_namespace" {
  description = "Namespace where AI Gateway is installed"
  value       = var.ai_gateway_namespace
}

output "envoy_gateway_namespace" {
  description = "Namespace where Envoy Gateway is installed"
  value       = var.envoy_gateway_namespace
}

output "redis_namespace" {
  description = "Namespace where Redis is installed"
  value       = var.enable_redis ? var.redis_namespace : null
}
