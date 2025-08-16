variable "kube_host" {
  type        = string
  description = "API server endpoint link"
}

variable "kube_client_key" {
  type        = string
  description = "Input the Client key"
}


variable "kube_client_certificate" {
  type = string
  description = "client certificate"
}

variable "kube_cluster_ca_certificate" {
  type        = string
  description = "Client cluster ca certificate"
}

variable "kube_token" {
  type        = string
  description = "Path to the kubeconfig file"
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
