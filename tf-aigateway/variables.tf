variable "kubeconfig" {
  description = "Path to kubeconfig used by the Helm and Kubernetes providers"
  type        = string
  default     = "~/.kube/config"
}