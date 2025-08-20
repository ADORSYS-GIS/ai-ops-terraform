module "kserve_namespace" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository                    = "https://charts.itscontained.io"
  chart                         = "raw"
  name                          = "kserve-namespace"
  namespace                     = var.namespace
  chart_version                 = "0.2.5"
  eks_cluster_oidc_issuer_url   = var.eks_cluster_oidc_issuer_url
  values = [
    templatefile("${path.module}/files/kserve-namespace-values.yaml.tpl", { namespace = var.namespace })
  ]
}

module "kserve_crd" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository                    = "oci://ghcr.io/kserve"
  chart                         = "charts/kserve-crd"
  name                          = "kserve-crd"
  namespace                     = var.namespace
  chart_version                 = var.kserve_version
  eks_cluster_oidc_issuer_url   = var.eks_cluster_oidc_issuer_url

  depends_on = [
    module.kserve_namespace
  ]
}

module "kserve" {
  source  = "cloudposse/helm-release/aws"
  version = "0.10.1"

  repository                    = "oci://ghcr.io/kserve"
  chart                         = "charts/kserve"
  name                          = "kserve"
  namespace                     = var.namespace
  chart_version                 = var.kserve_version
  eks_cluster_oidc_issuer_url   = var.eks_cluster_oidc_issuer_url

  depends_on = [
    module.kserve_crd
  ]

  values = [
    templatefile("${path.module}/files/kserve-values.yaml.tpl", { namespace = var.namespace })
  ]
}