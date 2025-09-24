variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for your EKS cluster's API server."
  type        = string
}

variable "node_iam_role_arn" {
  description = "The ARN of the IAM role for the Karpenter nodes."
  type        = string
}

variable "instance_profile" {
  description = "The instance profile for the Karpenter nodes."
  type        = string
}

variable "custom_ami_id" {
  description = "The ID of a custom AMI to use for Karpenter nodes. If empty, Karpenter will use the default."
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The Kubernetes namespace in which to install Karpenter."
  type        = string
  default     = "karpenter"
}

variable "create_namespace" {
  description = "Whether to create the namespace if it does not exist."
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "The version of the Karpenter Helm chart to install."
  type        = string
  default     = "1.4.0"
}

variable "tags" {
  description = "A map of tags to apply to the resources."
  type        = map(string)
  default     = {}
}