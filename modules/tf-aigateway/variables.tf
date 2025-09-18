variable "chart_version" {
  type        = string
  description = "Version of the Helm charts"
  default     = "v0.0.0-latest"
}

variable "ai_gateway_namespace" {
  type        = string
  description = "Namespace for AI Gateway components"
  default     = "envoy-ai-gateway-system"
}

variable "envoy_gateway_namespace" {
  type        = string
  description = "Namespace for Envoy Gateway"
  default     = "envoy-gateway-system"
}

variable "redis_namespace" {
  type        = string
  description = "Namespace for Redis (note: this is referenced in YAML manifests; changing it may require updating the YAML content)"
  default     = "redis-system"
}

variable "enable_redis" {
  description = "Whether to deploy the Redis Helm chart"
  type        = bool
}
