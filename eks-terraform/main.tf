
# ============================================================================
# Data Sources
# ============================================================================

data "aws_availability_zones" "available" {
  state = "available"
}

# ============================================================================
# Local Values
# ============================================================================

locals {
  cluster_name = "script-dev-eks"
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.name
    ClusterName = local.cluster_name
  }
}

# ============================================================================
# VPC Module
# ============================================================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k + 3)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Required tags for EKS
  public_subnet_tags = {
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"             = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  tags = local.tags
}

# ============================================================================
# EKS Cluster (Minimal - No Node Groups)
# ============================================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
  enable_irsa                    = true

  cluster_addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
  }

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default_nodes = {
      # Node Group Scaling Configuration
      desired_capacity = 2
      max_capacity     = 5
      min_capacity     = 1
      
      # Instance Type and Capacity
      instance_type = "t3.medium"
      capacity_type = "ON_DEMAND"
      
      # Disk Configuration
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 80
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
            encrypted             = true
          }
        }
      }
      
      # Instance Resource Configuration
      instance_requirements = {
        cpu_manufacturers  = ["intel", "amd"]
        memory_mib = {
          min = 4096  # 4GB
        }
        vcpu_count = {
          min = 2
          max = 4
        }
      }
      
      # Subnets and Networking
      subnet_ids = module.vpc.private_subnets
      
      # Update Configuration
      update_config = {
        max_unavailable_percentage = 33
      }
      
      # Labels and Taints
      labels = {
        role = "general"
      }
      
      taints = [
        {
          key    = "dedicated"
          value  = "general"
          effect = "NO_SCHEDULE"
        }
      ]
      
      # Monitoring and Logging
      enable_monitoring = true
      
      # Tags
      tags = merge(local.tags, {
        Name = "${local.cluster_name}-node"
      })
    }
  }

  tags = local.tags
}
