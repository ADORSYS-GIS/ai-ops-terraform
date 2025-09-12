module "custom_karpenter_ami" {
  source = "./modules/custom-ami"

  ami_name            = "karpenter-custom"
  base_ami_version    = var.cluster_version # Align to EKS version
  build_instance_type = "t3.large"

  component_version = "1.0.1"

  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = []

  tags = {
    Project   = "AI-TF"
    ManagedBy = "Terraform"
  }
}
