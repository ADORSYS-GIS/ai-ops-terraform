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
  description = "The storage URI for the LLM model (required - e.g., s3://your-bucket/model-path, gs://your-bucket/model-path, or pvc://your-pvc/model-path)"
  type        = string
  default     = ""
}