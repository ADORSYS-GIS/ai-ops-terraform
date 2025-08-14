output "argocd_server_url" {
  value     = "https://${local.argocdDomain}"
  sensitive = false

}

output "kserve_namespace" {
  value = module.kserve.kserve_namespace
}
