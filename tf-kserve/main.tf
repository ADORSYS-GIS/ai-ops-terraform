module "kserve_namespace" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository = "https://charts.itscontained.io"
  chart      = "raw"
  name       = "kserve-namespace"
  namespace  = var.namespace
  chart_version = "0.2.5"
  values = [
    yamlencode({
      apiVersion = "v1",
      kind       = "Namespace",
      metadata   = {
        name = var.namespace
      }
    })
  ]
}

module "cert_manager" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  name       = "cert-manager"
  namespace  = "cert-manager"
  chart_version    = "v1.10.0"

  depends_on = [
    module.gateway_api
  ]
}

module "gateway_api" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository = "https://kubernetes-sigs.github.io/gateway-api"
  chart      = "gateway-api"
  name       = "gateway-api"
  namespace  = "gateway-api"
  chart_version    = "v1.0.0"
}

module "gatewayclass" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"
  repository = "https://charts.itscontained.io"

  chart      = "raw"
  name       = "gatewayclass"
  namespace  = "gateway-api"
  chart_version    = "0.2.5"
  values = [
    yamlencode({
      apiVersion = "gateway.networking.k8s.io/v1",
      kind       = "GatewayClass",
      metadata   = {
        name = "envoy"
      },
      spec = {
        controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
      }
    })
  ]

  depends_on = [
    module.gateway_api
  ]
}

module "gateway" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository = "https://charts.itscontained.io"
  chart      = "raw"
  name       = "gateway"
  namespace  = var.namespace
  chart_version    = "0.2.5"

  values = [
    yamlencode({
      apiVersion = "gateway.networking.k8s.io/v1",
      kind       = "Gateway",
      metadata   = {
        name      = "kserve-ingress-gateway",
        namespace = var.namespace
      },
      spec = {
        gatewayClassName = "envoy",
        listeners = concat(
          [
            {
              name     = "http",
              protocol = "HTTP",
              port     = 80,
              allowedRoutes = {
                namespaces = { from = "All" }
              }
            }
          ],
          var.tls_certificate_name != "" ? [
            {
              name     = "https",
              protocol = "HTTPS",
              port     = 443,
              tls = {
                mode            = "Terminate",
                certificateRefs = [
                  {
                    kind = "Secret",
                    name = var.tls_certificate_name
                  }
                ]
              }
            }
          ] : []
        )
      }
    })
  ]
}

module "kserve_crd" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository = "oci://ghcr.io/kserve"
  chart      = "charts/kserve-crd"
  name       = "kserve-crd"
  namespace  = var.namespace
  chart_version    = var.kserve_version

  depends_on = [
    module.gateway
  ]
}

module "kserve" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository = "oci://ghcr.io/kserve"
  chart      = "charts/kserve"
  name       = "kserve"
  namespace  = var.namespace
  chart_version    = var.kserve_version

  depends_on = [
    module.kserve_crd
  ]

  values = [
    templatefile("${path.module}/files/kserve-values.yaml.tpl", { namespace = var.namespace })
  ]
}
