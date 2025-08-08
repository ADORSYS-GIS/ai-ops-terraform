variable "kube_host" {
  description = "Kubernetes API server endpoint"
  type        = string
}

variable "kube_token" {
  description = "Kubernetes auth token"
  type        = string
  sensitive   = true
}

variable "kube_ca_cert" {
  description = "Kubernetes cluster CA certificate"
  type        = string
}

variable "kube_client_cert" {
  description = "Kubernetes client certificate"
  type        = string
}

variable "kube_client_key" {
  description = "Kubernetes client key"
  type        = string
}

variable "kserve_chart_version" {
  description = "KServe Helm chart version"
  type        = string
  default     = "0.11.2"
}

variable "kserve_version" {
  type    = string
  default = "v0.15.2"
}

variable "tls_certificate_name" {
  description = "Name of the TLS certificate secret"
  type        = string
}

variable "install_gateway_api" {
  description = "Install Gateway API components"
  type        = bool
  default     = false
}

variable "install_cert_manager" {
  description = "Install Cert Manager components"
  type        = bool
  default     = false
}

variable "install_knative" {
  description = "Install Knative components"
  type        = bool
  default     = false
}
