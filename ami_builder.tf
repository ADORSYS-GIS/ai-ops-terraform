module "custom_karpenter_ami" {
  source = "./modules/custom-ami"

  ami_name                  = "karpenter-custom"
  base_ami_version          = "1.28" # Corresponds to an EKS version
  build_instance_type       = "t3.large"
  
  component_version         = "1.0.1"

  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.default.id]

  tags = {
    Project   = "AI-TF"
    ManagedBy = "Terraform"
  }
}
