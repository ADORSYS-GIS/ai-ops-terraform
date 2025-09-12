variable "namespace" {
  description = "Namespace where lmcache will be installed"
  type        = string
  default     = "vllm-lmcache"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "vllm-stack-lmcache"
}

variable "helm_repo" {
  description = "Helm chart repository URL for lmcache"
  type        = string
  default     = "https://vllm-project.github.io/production-stack"
}

variable "helm_chart" {
  description = "Helm chart name for lmcache"
  type        = string
  default     = "vllm-stack"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "0.1.4"
}
