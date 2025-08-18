# Main module to deploy Argo CD using Helm
module "argocd" {
  source  = "terraform-module/release/helm"
  version = "2.9.1"

  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"

  # Helm chart/application settings
  app = {
    name          = "argocd"          # helm release name
    description   = "Argo CD via Terraform helm-release module"
    chart         = "argo-cd"         # chart name in the repo
    version       = "6.0.0"           # (optional) chart version; omit for latest
    force_update  = true
    wait          = true
    recreate_pods = false
    deploy        = 1                 # keep as 1 to enable deployment
    create_namespace = true
  }

  # Inline values.yaml (merge as you like)
  values = [
    yamlencode({
      server = {
        service = { type = "LoadBalancer" }  # change to NodePort/ClusterIP if needed
      }
      # Example: pass Argo CD params
      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]
}