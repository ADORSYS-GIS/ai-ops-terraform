output "envoy_gateway_release_name" {
  value = helm_release.envoy_gateway.name
}

output "ai_gateway_release_name" {
  value = helm_release.ai_gateway.name
}

output "ai_gateway_crds_release_name" {
  value = helm_release.ai_gateway_crds.name
}