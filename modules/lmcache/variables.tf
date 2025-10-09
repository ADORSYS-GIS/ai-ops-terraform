variable "release_name" {
  description = "The name of the Helm release."
  type        = string
  default     = "lmcache"
}

variable "namespace" {
  description = "The namespace to deploy the LMCache into."
  type        = string
  default     = "lmcache"
}

variable "chart_version" {
  description = "The version of the Helm chart to deploy"
  type        = string
  default     = "0.1.0"
}

variable "replica_count" {
  description = "The number of replicas for the LMCache."
  type        = number
  default     = 1
}


# Only include settings that your specific application needs
variable "storage_uri" {
  description = "The storage URI for the LLM model."
  type        = string
  default     = ""
}