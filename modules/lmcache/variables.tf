variable "release_name" {
  description = "The name of the Helm release."
  type        = string
  default     = "lmcache-inference"
}

variable "namespace" {
  description = "The namespace to deploy the InferenceService into."
  type        = string
  default     = "lmcache"
}

variable "image_tag" {
  description = "The image tag for the LMCache-enabled vLLM predictor."
  type        = string
  default     = "latest"
}

variable "storage_uri" {
  description = "The storage URI for the LLM model. If not provided, it will default to the Redis endpoint if available."
  type        = string
  default     = ""
}

variable "chart_version" {
  description = "The version of the Helm chart to deploy"
  type        = string
  default     = "0.1.0"
}