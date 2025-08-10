variable "helm_repository" {
  description = "The Helm repository to use"
  type        = string
  default     = "oci://docker.io/envoyproxy"
}

variable "crd_chart" {
  description = "The CRD Helm chart name"
  type        = string
  default     = "ai-gateway-crds-helm"
}

variable "ai_gateway_chart" {
  description = "The AI Gateway Helm chart name"
  type        = string
  default     = "ai-gateway-helm"
}

variable "envoy_gateway_chart" {
  description = "The Envoy Gateway Helm chart name"
  type        = string
  default     = "gateway-helm"
}

variable "crd_version" {
  description = "The version of the CRD chart"
  type        = string
  default     = "v0.0.0-latest"
}

variable "ai_gateway_version" {
  description = "The version of the AI Gateway chart"
  type        = string
  default     = "v0.0.0-latest"
}

variable "envoy_gateway_version" {
  description = "The version of the Envoy Gateway chart"
  type        = string
  default     = "v0.0.0-latest"
}

variable "ai_gateway_namespace" {
  description = "The namespace for AI Gateway"
  type        = string
  default     = "envoy-ai-gateway-system"
}

variable "envoy_gateway_namespace" {
  description = "The namespace for Envoy Gateway"
  type        = string
  default     = "envoy-gateway-system"
}