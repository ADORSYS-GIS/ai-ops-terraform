variable "region" {
  description = "The AWS region to deploy resources to"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_version" {
  description = "The version of the cluster"
  type        = string
  default     = "1.32"
}

variable "name" {
  description = "The name of the cluster"
  type        = string
  default     = "ai"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "11.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones for the VPC"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "environment" {
  description = "The environment to deploy resources to"
  type        = string
  default     = "dev"
}

variable "cpu_ec2_instance_types" {
  description = "The EC2 instance type for the CPU server"
  type        = list(string)
  default = ["t3.medium", "t3.large"]
}

variable "cpu_min_instance" {
  description = "The minimum number of instances for the CPU cluster"
  type        = number
  default     = 0
}

variable "cpu_max_instance" {
  description = "The maximum number of instances for the CPU cluster"
  type        = number
  default     = 2
}

variable "cpu_desired_instance" {
  description = "The desired number of instances for the CPU cluster"
  type        = number
  default     = 0
}

variable "cpu_capacity_type" {
  type        = string
  default     = "SPOT"
  description = "MLFlow EC2 Capacity type"
}

variable "mlflow_ec2_instance_types" {
  description = "The EC2 instance type for the MLFlow server"
  type        = list(string)
  default = ["t3.medium", "t3.large", "m5.large"]
}

variable "mlflow_min_instance" {
  description = "The minimum number of instances for the MLFlow cluster"
  type        = number
  default     = 0
}

variable "mlflow_max_instance" {
  description = "The maximum number of instances for the MLFlow cluster"
  type        = number
  default     = 2
}

variable "mlflow_desired_instance" {
  description = "The desired number of instances for the MLFlow cluster"
  type        = number
  default     = 0
}

variable "mlflow_capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "MLFlow EC2 Capacity type"
}

variable "knative_ec2_instance_types" {
  description = "The EC2 instance type for the Knative server"
  type        = list(string)
  default = [
    # a10g
    "g5.xlarge",
    "g5.2xlarge",
    "g5.4xlarge",
    "g5.8xlarge",
    "g5.12xlarge",
    "g5.16xlarge",
    "g5.24xlarge",

    # l4
    "g6.xlarge",
    "g6.2xlarge",
    "g6.4xlarge",
    "g6.8xlarge",
    "g6.12xlarge",
    "g6.16xlarge",
    "g6.24xlarge",
    "g6.48xlarge",

    # l40s
    "g6e.xlarge",
    "g6e.2xlarge",
    "g6e.4xlarge",
    "g6e.8xlarge",
    "g6e.12xlarge",
    "g6e.16xlarge",
    "g6e.24xlarge",
    "g6e.48xlarge",
  ]
}

variable "knative_min_instance" {
  description = "The minimum number of instances for the Knative cluster"
  type        = number
  default     = 0
}

variable "knative_max_instance" {
  description = "The maximum number of instances for the Knative cluster"
  type        = number
  default     = 2
}

variable "knative_desired_instance" {
  description = "The desired number of instances for the Knative cluster"
  type        = number
  default     = 0
}

variable "knative_capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "Knative EC2 Capacity type"
}

variable "zone_name" {
  description = "The name of the Route 53 zone"
  type        = string
}

variable "cert_arn" {
  description = "The ARN of the SSL certificate"
  type        = string
}

variable "oidc_kc_client_id" {
  description = "The client ID for the OIDC provider"
  type        = string
  sensitive   = true
}

variable "oidc_kc_client_secret" {
  description = "The client secret for the OIDC provider"
  type        = string
  sensitive   = true
}

variable "oidc_kc_issuer_url" {
  description = "The issuer URL for the OIDC provider"
  type        = string
}

#======
variable "pipeline_key" {
  type        = string
  sensitive   = true
  description = "Pipeline Key"
}

variable "litelllm_masterkey" {
  type        = string
  sensitive   = true
  description = "LiteLLM Master Key"
}

variable "webui_secret_key" {
  type        = string
  sensitive   = true
  description = "WebUI Secret Key"
}

variable "tool_api_key" {
  type        = string
  sensitive   = true
  description = "Tool API Key"
}

variable "brave_api_key" {
  type        = string
  sensitive   = true
  description = "Brave API Key"
}

variable "anthropic_key" {
  type        = string
  sensitive   = true
  description = "Anthropic API Key"
}

variable "gemini_key" {
  type        = string
  sensitive   = true
  description = "Gemini API Key"
}

variable "openai_key" {
  type        = string
  sensitive   = true
  description = "OpenAI API Key"
}

variable "fireworks_key" {
  type        = string
  sensitive   = true
  description = "Firework Key"
}


variable "s3_buckets" {
  description = "Map of S3 buckets to create with their configurations, users, and K8s secrets"
  type = map(object({
    enabled            = optional(bool, true)
    versioning_enabled = optional(bool, false)
    encryption_type    = optional(string, "AES256")
    users = map(object({
      permissions = list(string) # ["read", "write", "delete", "list"]
    }))
    k8s_secrets = optional(map(object({
      namespace   = string
      secret_name = string
      user_key    = string                    # Which user's credentials to use
      extra_data  = optional(map(string), {}) # Additional secret data
    })), {})
  }))
  default = {}
}


variable "kserve_version" {
  description = "The version of KServe to install"
  type        = string
  default     = "v0.15.2"
}


variable "enable_ai_gateway_redis" {
  description = "Whether to deploy Redis for the AI Gateway"
  type        = bool
  default     = true
}

variable "redis_auth_token" {
  description = "The authentication token (password) for the Redis cluster."
  type        = string
  sensitive   = true
}

variable "redis_node_type" {
  description = "The instance type for the Redis nodes."
  type        = string
  default     = "cache.t4g.small"
}

variable "redis_num_node_groups" {
  description = "The number of node groups (shards) for the Redis replication group."
  type        = number
  default     = 1
}

