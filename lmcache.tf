module "lmcache" {
  source = "./modules/lmcache"

  release_name = "lmcache"
  namespace    = "lmcache"
  chart_version = "0.1.3"
  replica_count = 1
}