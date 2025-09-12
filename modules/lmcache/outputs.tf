output "lmcache_namespace" {
  description = "Namespace where lmcache is deployed"
  value       = var.namespace
}

output "lmcache_release" {
  description = "Helm release name"
  value       = helm_release.lmcache.name
}

output "lmcache_status" {
  description = "Helm release status"
  value       = helm_release.lmcache.status
}
