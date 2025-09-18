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
  description = "The storage URI for the LLM model"
  type        = string
  
  validation {
    condition = var.storage_uri != ""
    error_message = "The storage_uri variable must be provided and cannot be empty. Please specify a valid storage URI (e.g., s3://bucket/path, gs://bucket/path, or pvc://pvc-name/path)."
  }
}

variable "chart_version" {
  description = "The version of the Helm chart to deploy"
  type        = string
  default     = "0.1.0"
}