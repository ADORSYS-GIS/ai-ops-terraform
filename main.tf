terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

# --- 1. Install AI Gateway CRDs ---
resource "helm_release" "ai_gateway_crds" {
  name             = "aieg-crd"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "ai-gateway-crds-helm"
  version          = "v0.0.0-latest"
  namespace        = "envoy-ai-gateway-system"
  create_namespace = true
}

# --- 2. Install AI Gateway (skip CRDs) ---
resource "helm_release" "ai_gateway" {
  name             = "aieg"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "ai-gateway-helm"
  version          = "v0.0.0-latest"
  namespace        = "envoy-ai-gateway-system"
  create_namespace = true
  skip_crds        = true
  depends_on       = [helm_release.ai_gateway_crds]
}

# --- 3. Install Envoy Gateway ---
resource "helm_release" "envoy_gateway" {
  name             = "eg"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "gateway-helm"
  version          = "v0.0.0-latest"
  namespace        = "envoy-gateway-system"
  create_namespace = true
  depends_on       = [helm_release.ai_gateway]
}

data "http" "redis_yaml" {
  url = "https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/redis.yaml"
}

data "http" "config_yaml" {
  url = "https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/config.yaml"
}

data "http" "rbac_yaml" {
  url = "https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/rbac.yaml"
}


# 5. Envoy Gateway configuration (config.yaml)
resource "kubectl_manifest" "envoy_gateway_config" {
  yaml_body = data.http.config_yaml.body
}

resource "kubectl_manifest" "redis" {
  yaml_body = data.http.redis_yaml.body

  server_side_apply = true
  field_manager     = "terraform"

  depends_on = [
    helm_release.envoy_gateway,
    kubectl_manifest.envoy_gateway_config
  ]
}

resource "kubectl_manifest" "envoy_gateway_rbac" {
  yaml_body = data.http.rbac_yaml.body
  depends_on = [
    kubectl_manifest.redis,
    kubectl_manifest.envoy_gateway_config,
  ]
}

resource "kubectl_manifest" "restart_envoy_gateway" {
  yaml_body = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: envoy-gateway
      namespace: envoy-gateway-system
      annotations:
        restart-time: "${timestamp()}"
  YAML

  force_new = true # ensures change is applied on each timestamp update
  depends_on = [
    kubectl_manifest.redis,
    helm_release.ai_gateway,
    helm_release.ai_gateway_crds,
    helm_release.envoy_gateway,
    kubectl_manifest.envoy_gateway_rbac
  ]
}
