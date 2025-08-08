# ----------------------------
# Variables (override with -var or a tfvars file)
# ----------------------------
variable "kubeconfig" {
  description = "Path to kubeconfig used by the Helm and Kubernetes providers"
  type        = string
  default     = "~/.kube/config"
}

variable "gateway_crds_chart_version" {
  description = "Chart version for the Envoy Gateway CRDs chart"
  type        = string
  default     = "v0.0.0-latest"
}

variable "gateway_chart_version" {
  description = "Chart version for the Envoy Gateway main chart"
  type        = string
  default     = "v0.0.0-latest"
}

variable "ai_gateway_crds_chart_version" {
  description = "Chart version for the Envoy AI Gateway CRDs chart"
  type        = string
  default     = "v0.0.0-latest"
}

variable "ai_gateway_chart_version" {
  description = "Chart version for the Envoy AI Gateway main chart"
  type        = string
  default     = "v0.1.0"
}