terraform {
  required_version = ">= 1.9.8"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }
}

resource "kubernetes_namespace" "kserve" {
  metadata {
    name = "kserve"
  }
}


# 1. Install cert-manager
resource "null_resource" "install_cert_manager" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml"
  }
}

# 2. Install Gateway API network controller
resource "null_resource" "install_gateway_api" {
  depends_on = [null_resource.install_cert_manager]
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml"
  }
}

# 3. Create GatewayClass and Gateway in kserve namespace
resource "kubernetes_manifest" "gatewayclass" {
  depends_on = [null_resource.install_gateway_api]
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"
    metadata = {
      name = "envoy"
    }
    spec = {
      controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
    }
  }
}

resource "kubernetes_manifest" "gateway" {
  depends_on = [kubernetes_manifest.gatewayclass]
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = "kserve-ingress-gateway"
      namespace = "kserve"
    }
    spec = {
      gatewayClassName = "envoy"
      listeners = concat([
        {
          name          = "http"
          protocol      = "HTTP"
          port          = 80
          allowedRoutes = { namespaces = { from = "All" } }
        }
        ], var.tls_certificate_name != "" ? [{
          name     = "https"
          protocol = "HTTPS"
          port     = 443
          tls      = { mode = "Terminate", certificateRefs = [{ kind = "Secret", name = var.tls_certificate_name }] }
      }] : [])
    }
  }
}


resource "helm_release" "kserve_crd" {
  depends_on       = [kubernetes_manifest.gateway]
  name             = "kserve-crd"
  repository       = "oci://ghcr.io/kserve"
  chart            = "charts/kserve-crd"
  version          = var.kserve_version
  namespace        = kubernetes_namespace.kserve.metadata[0].name
  create_namespace = false
}

resource "helm_release" "kserve" {
  depends_on       = [helm_release.kserve_crd]
  name             = "kserve"
  repository       = "oci://ghcr.io/kserve"
  chart            = "charts/kserve"
  version          = var.kserve_version
  namespace        = kubernetes_namespace.kserve.metadata[0].name
  create_namespace = false

  values = [
    file("${path.module}/values/kserve-values.yaml")
  ]
}



