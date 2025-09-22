module "lmcache" {
  source       = "./modules/lmcache"
  ingress_host = "${local.name}-lmcache.${var.zone_name}"

  # Use the actual Redis deployment from our Redis module
  redis_host       = var.enable_ai_gateway_redis ? module.redis.cluster_address : ""
  redis_port       = 6379
  redis_auth_token = var.enable_ai_gateway_redis ? var.redis_auth_token : ""
  
  # Let the module construct Redis URLs automatically
  # storage_uri will be built from redis_host/port/auth_token
  
  lmcache_settings = {
    chunkSize        = "512"
    localCpu         = "True"
    localDisk        = "file:///tmp/lmcache"
    maxLocalDiskSize = "10.0"
    enableP2P        = "False"
    # remoteUrl will be constructed automatically by the module
  }

  depends_on = [module.redis, module.ai_gateway]
}
