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
  default     = "v0.1.0"
}

variable "storage_uri" {
  description = "The storage URI for the LLM model. Can be S3, Redis, or other supported protocols."
  type        = string
  default     = ""
  
  validation {
    condition = var.storage_uri == "" || can(regex("^(s3://|gs://|pvc://|file://|redis://)", var.storage_uri))
    error_message = "The storage_uri must be empty or start with a valid protocol (s3://, gs://, pvc://, file://, redis://)."
  }
}

variable "redis_host" {
  description = "Redis host for LMCache remote storage"
  type        = string
  default     = ""
}

variable "redis_port" {
  description = "Redis port for LMCache remote storage"
  type        = number
  default     = 6379
}

variable "redis_auth_token" {
  description = "Redis authentication token for LMCache"
  type        = string
  default     = ""
  sensitive   = true
}

variable "chart_version" {
  description = "The version of the Helm chart to deploy"
  type        = string
  default     = "0.1.0"
}

variable "replica_count" {
  description = "The number of replicas for the inference service."
  type        = number
  default     = 2
}

variable "resources" {
  description = "The compute resources for the inference service."
  type = object({
    requests = object({
      memory = string
      cpu    = string
      "nvidia.com/gpu" = string
    })
    limits = object({
      memory = string
      cpu    = string
      "nvidia.com/gpu" = string
    })
  })
  default = {
    requests = {
      memory = "8Gi"   
      cpu    = "4000m"  
      "nvidia.com/gpu" = "1"
    }
    limits = {
      memory = "16Gi"  
      cpu    = "8000m"  
      "nvidia.com/gpu" = "1"
    }
  }
}

variable "lmcache_settings" {
  description = "Configuration for the LMCache."
  type = object({
    chunkSize      = string
    localCpu       = string
    localDisk      = string
    maxLocalDiskSize = string
    remoteUrl      = string
    enableP2P      = string
    lookupUrl      = optional(string)
    distributedUrl = optional(string)
  })
  default = {
    chunkSize      = "512"  
    localCpu       = "True"
    localDisk      = "file:///tmp/lmcache"  
    maxLocalDiskSize = "10.0"  
    remoteUrl      = ""  # Will be constructed dynamically
    enableP2P      = "False"
  }
}


variable "ingress_host" {
  description = "The hostname for the ingress resource."
  type        = string
  default     = ""
}

variable "ingress" {
  description = "Configuration for the ingress resource."
  type = object({
    enabled = bool
    hosts = list(object({
      host = string
      paths = list(object({
        path     = string
        pathType = string
      }))
    }))
    tls = list(object({
      secretName = string
      hosts      = list(string)
    }))
  })
  default = {
    enabled = true
    hosts = []
    tls = []
  }
}

variable "node_selector" {
  description = "Node selector for pod placement (e.g., for GPU nodes)"
  type        = map(string)
  default = {
    "node.kubernetes.io/instance-type" = "g4dn.xlarge"
  }
}

variable "tolerations" {
  description = "Tolerations for pod scheduling"
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
  }))
  default = [
    {
      key      = "nvidia.com/gpu"
      operator = "Equal"
      value    = "true"
      effect   = "NoSchedule"
    }
  ]
}