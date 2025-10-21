module "custom_karpenter_ami" {
  source = "./modules/custom-ami"

  ami_name                  = "karpenter-custom"
  base_ami_version          = "1.28" # Corresponds to an EKS version
  build_instance_type       = "t3.large"
  
  component_version         = "1.0.1"
  customization_script_path = null

  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.default.id]

  tags = {
    Project   = "AI-TF"
    ManagedBy = "Terraform"
  }
}

module "k_server_custom_ami" {
  source = "./modules/custom-ami"

  ami_name                  = "k-server-custom"
  base_ami_version          = "1.28" # Corresponds to an EKS version
  build_instance_type       = "t3.large"
  component_version         = "1.0.0"
  customization_script_path = "${path.module}/scripts/k_server_customization_script.sh"

  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.default.id]

  tags = {
    Project   = "AI-TF"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "default" {
  name        = "default-ami-builder"
  description = "Default security group for AMI builder"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  }
}

