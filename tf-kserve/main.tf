module "kserve_namespace" {
  source = "terraform-module/release/helm"
  version = "2.9.1"

  app = {
    name = "kserve-namespace"
    chart = "raw"
    version = "0.2.5"
    repository = "https://charts.itscontained.io"
  }
  namespace = var.namespace
  values = [
    yamlencode({
      apiVersion = "v1"
      kind = "Namespace"
      metadata = {
        name = var.namespace
      }
    })
  ]
}

module "cert_manager" {
  source = "terraform-module/release/helm"
  version = "2.9.1"

  app = {
    name = "cert-manager"
    chart = "cert-manager"
    version = "v1.10.0"
    repository = "https://charts.jetstack.io"
  }
  namespace = "cert-manager"
  create_namespace = true

  depends_on = [
    module.gateway_api
  ]
}

module "gateway_api" {
  source = "terraform-module/release/helm"
  version = "2.9.1"

  app = {
    name = "gateway-api"
    chart = "gateway-api"
    version = "v1.0.0"
    repository = "https://kubernetes-sigs.github.io/gateway-api"
  }
  namespace = "gateway-api"
  create_namespace = true
}

module "gatewayclass" {
  source = "terraform-module/release/helm"
  version = "2.9.1"

  app = {
    name = "gatewayclass"
    chart = "raw"
    version = "0.2.5"
    repository = "https://charts.itscontained.io"
  }
  namespace = "gateway-api"
  values = [
    yamlencode({
      apiVersion = "gateway.networking.k8s.io/v1"
      kind = "GatewayClass"
      metadata = {
        name = "envoy"
      }
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
  source = "terraform-module/release/helm"
  version = "2.9.1"

  app = {
    name = "gateway"
    chart = "raw"
    version = "0.2.5"
    repository = "https://charts.itscontained.io"
  }
  namespace = var.namespace
  values = [
    yamlencode({
      apiVersion = "gateway.networking.k8s.io/v1"
      kind = "Gateway"
      metadata = {
        name = "kserve-ingress-gateway"
        namespace = var.namespace
      }
      spec = {
        gatewayClassName = "envoy"
        listeners = concat([
          {
            name = "http"
            protocol = "HTTP"
            port = 80
            allowedRoutes = { namespaces = { from = "All" } }
          },
        ], var.tls_certificate_name != "" ? [{
            name = "https"
            protocol = "HTTPS"
            port = 443
            tls = { mode = "Terminate", certificateRefs = [{ kind = "Secret", name = var.tls_certificate_name }] }
          }] : [])
        }
      }
    })
  ]
}


module "kserve_crd" {
  source = "terraform-module/release/helm"
  version = "2.9.1"

  app = {
    name = "kserve-crd"
    chart = "charts/kserve-crd"
    version = var.kserve_version
    repository = "oci://ghcr.io/kserve"
  }
  namespace = var.namespace
  create_namespace = false

  depends_on = [
    module.gateway
  ]
}

module "kserve" {
  source = "terraform-module/release/helm"
  version = "2.9.1"

  app = {
    name = "kserve"
    chart = "charts/kserve"
    version = var.kserve_version
    repository = "oci://ghcr.io/kserve"
  }
  namespace = var.namespace
  create_namespace = false

  depends_on = [
    module.kserve_crd
  ]

  values = [
    templatefile("${path.module}/files/kserve-values.yaml.tpl", { namespace = var.namespace })
  ]
}