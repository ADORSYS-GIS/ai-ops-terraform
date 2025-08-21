variable "namespace" {
  description = "The Kubernetes namespace to install KServe into."
  type        = string
  default     = "kserve"
}

variable "kserve_version" {
  type    = string
  default = "v0.15.2"
}

variable "eks_cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster."
  type        = string
}