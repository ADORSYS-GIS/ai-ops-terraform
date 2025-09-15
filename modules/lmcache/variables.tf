variable "release_name" {
  description = "The name of the Helm release."
  type        = string
  default     = "lmcache-inference"
}

variable "namespace" {
  description = "The namespace to deploy the InferenceService into."
  type        = string
  default     = "default"
}

variable "image_tag" {
  description = "The image tag for the LMCache-enabled vLLM predictor."
  type        = string
  default     = ""
}

variable "storage_uri" {
  description = "The storage URI for the LLM model"
  type        = string
  default     = ""
}