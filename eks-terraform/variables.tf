variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "name" {
  description = "Cluster name prefix"
  type        = string
  default     = "script"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}