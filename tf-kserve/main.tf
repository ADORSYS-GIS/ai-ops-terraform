resource "kubernetes_namespace" "kserve" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "cert_manager" {
  count            = var.install_cert_manager ? 1 : 0
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.10.0"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true
}

resource "helm_release" "gateway_api" {
  count      = var.install_gateway_api ? 1 : 0
  name       = "gateway-api"
  repository = "https://kubernetes-sigs.github.io/gateway-api"
  chart      = "gateway-api"
  version    = "v1.0.0"
  namespace  = "gateway-api"
  wait       = true
}

resource "kubernetes_manifest" "gatewayclass" {
  depends_on = [helm_release.gateway_api]
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
      namespace = var.namespace
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
  namespace        = var.namespace
  create_namespace = false
}

resource "helm_release" "kserve" {
  depends_on       = [helm_release.kserve_crd]
  name             = "kserve"
  repository       = "oci://ghcr.io/kserve"
  chart            = "charts/kserve"
  version          = var.kserve_version
  namespace        = var.namespace
  create_namespace = false

  values = [
    templatefile("${path.module}/files/kserve-values.yaml.tpl", { namespace = var.namespace })
  ]
}