terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Mock provider configuration for testing
provider "helm" {
  # For testing without actual Kubernetes cluster
  # kubernetes {
  #   config_path = "~/.kube/config"
  # }
}

# Test the lmcache module
module "lmcache_test" {
  source = "../modules/lmcache"
  
  # Required variables
  ingress_host = "test-lmcache.example.com"
  
  # Redis configuration for testing
  redis_host       = "redis.test.svc.cluster.local"
  redis_port       = 6379
  redis_auth_token = "test-auth-token"
  
  # Optional overrides for testing
  replica_count = 1
  image_tag     = "v0.1.0"
  
  # Test ingress configuration
  ingress = {
    enabled = true
    hosts   = []
    tls     = []
  }
}

# Output for verification
output "lmcache_release_name" {
  value = module.lmcache_test.release_name
}

output "lmcache_namespace" {
  value = module.lmcache_test.namespace
}
