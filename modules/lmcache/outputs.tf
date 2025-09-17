output "release_name" {
  description = "The name of the deployed Helm release"
  value       = helm_release.lmcache_kserve_inference.name
}

output "namespace" {
  description = "The namespace where the release is deployed"
  value       = helm_release.lmcache_kserve_inference.namespace
}

output "chart_version" {
  description = "The version of the deployed Helm chart"
  value       = helm_release.lmcache_kserve_inference.version
}

output "status" {
  description = "The status of the Helm release"
  value       = helm_release.lmcache_kserve_inference.status
}
