output "kserve_namespace" {
  value = kubernetes_namespace.kserve.metadata[0].name
}
