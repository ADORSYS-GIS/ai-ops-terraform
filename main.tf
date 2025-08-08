terraform {
  required_version = ">= 1.0.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.4"
    }
  }
}


# ----------------------------
# Envoy Gateway: install CRDs first (separate release)
# ----------------------------
resource "helm_release" "envoy_gateway_crds" {
  name             = "eg-crds"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "gateway-crds-helm"
  version          = var.gateway_crds_chart_version
  namespace        = "envoy-gateway-system"
  create_namespace = true

  # Wait for CRD install to complete. CRDs can be large; give extra time.
  wait    = true
  timeout = 600
  cleanup_on_fail = true
}

# Main Envoy Gateway chart (skip CRDs because we installed them above)
resource "helm_release" "envoy_gateway" {
  name             = "eg"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "gateway-helm"
  version          = var.gateway_chart_version
  namespace        = "envoy-gateway-system"
  create_namespace = false   # namespace already created by CRDs release

  skip_crds = true

  # Wait until resources are available and allow more time if needed
  wait    = true
  timeout = 600
  cleanup_on_fail = true

  depends_on = [
    helm_release.envoy_gateway_crds,
  ]
}

# ----------------------------
# Envoy AI Gateway: CRDs then main chart
# ----------------------------
resource "helm_release" "ai_gateway_crds" {
  name             = "aieg-crds"
  repository       = "oci://registry-1.docker.io/envoyproxy"
  chart            = "ai-gateway-crds-helm"
  version          = var.ai_gateway_crds_chart_version
  namespace        = "envoy-ai-gateway-system"
  create_namespace = true

  wait    = true
  timeout = 600
  cleanup_on_fail = true
}

resource "helm_release" "ai_gateway" {
  name             = "aieg"
  repository       = "oci://registry-1.docker.io/envoyproxy"
  chart            = "ai-gateway-helm"
  version          = var.ai_gateway_chart_version
  namespace        = "envoy-ai-gateway-system"
  create_namespace = false

  skip_crds = true

  wait    = true
  timeout = 600
  cleanup_on_fail = true

  depends_on = [
    helm_release.ai_gateway_crds,
    helm_release.envoy_gateway, # ensure gateway is up first (if you require that order)
  ]
}


