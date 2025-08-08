variable "namespace" {
  description = "The Kubernetes namespace to install KServe into."
  type        = string
  default     = "kserve"
}

variable "kube_host" {
  description = "Kubernetes API server endpoint (for k3s, typically https://localhost:6443)"
  type        = string
  default     = "https://localhost:6443"
}

variable "kube_token" {
  description = "Kubernetes auth token (for k3s, can be found in /var/lib/rancher/k3s/server/token)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "kube_ca_cert" {
  description = "Base64 encoded certificate for the Kubernetes cluster"
  type        = string
}

variable "kube_client_cert" {
  description = "Base64 encoded client certificate for Kubernetes authentication"
  type        = string
}

variable "kube_client_key" {
  description = "Base64 encoded client key for Kubernetes authentication"
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
  default     = ""
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

