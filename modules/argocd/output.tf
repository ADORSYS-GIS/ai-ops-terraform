output "argocd_namespace" {
  value = module.argocd.namespace
}

output "argocd_server_service_name" {
  value = "argocd-server"
}