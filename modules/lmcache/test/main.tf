provider "kubernetes" {}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

module "lmcache" {
  source = "../"
}