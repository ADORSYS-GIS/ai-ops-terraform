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

# --- 4. Apply Redis deployment ---
resource "null_resource" "redis_config" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/redis.yaml"
  }
  depends_on = [helm_release.envoy_gateway]
}

# --- 5. Apply Envoy Gateway Config (ignore missing annotations warning) ---
resource "null_resource" "envoy_gateway_config" {
  provisioner "local-exec" {
    command = "kubectl apply --force -f https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/config.yaml || true"
  }
  depends_on = [null_resource.redis_config]
}

# --- 6. Apply RBAC rules ---
resource "null_resource" "envoy_gateway_rbac" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/envoyproxy/ai-gateway/main/manifests/envoy-gateway-config/rbac.yaml"
  }
  depends_on = [null_resource.envoy_gateway_config]
}

# --- 7. Restart Envoy Gateway deployment ---
resource "null_resource" "restart_envoy_gateway" {
  provisioner "local-exec" {
    command = <<EOT
kubectl rollout restart -n envoy-gateway-system deployment/envoy-gateway && \
kubectl wait --timeout=2m -n envoy-gateway-system deployment/envoy-gateway --for=condition=Available
EOT
  }
  depends_on = [null_resource.envoy_gateway_rbac]
}
