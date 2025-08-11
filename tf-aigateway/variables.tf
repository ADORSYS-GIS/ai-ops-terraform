variable "kube_config_path" {
  type        = string
  description = "Path to the kubeconfig file"
  default     = "~/.kube/config"
}

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

variable "redis_yaml_url" {
  type        = string
  description = "URL for the Redis YAML manifest"
  default     = "https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/redis.yaml"
}

variable "config_yaml_url" {
  type        = string
  description = "URL for the Envoy Gateway config YAML"
  default     = "https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/config.yaml"
}

variable "rbac_yaml_url" {
  type        = string
  description = "URL for the Envoy Gateway RBAC YAML"
  default     = "https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/rbac.yaml"
}
