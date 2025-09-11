module "argocd" {
  source  = "terraform-module/release/helm"
  version = "2.9.1"

  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"

  app = {
    name          = "argocd"          
    description   = "Argo CD via Terraform helm-release module"
    chart         = "argo-cd"         
    version       = "6.7.18"          
    force_update  = true
    wait          = true
    recreate_pods = false
    deploy        = 1                 
    create_namespace = true
  }

  values = []
}