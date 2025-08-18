module "custom_karpenter_ami" {
  source = "./modules/custom-ami"

  ami_name                  = "karpenter-custom"
  base_ami_version          = "1.28" # Corresponds to an EKS version
  build_instance_type       = "t3.large"
  customization_script_path = "${path.module}/files/provisioner.sh"
  component_version         = "1.0.1"

  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.default.id]

  tags = {
    Project   = "AI-TF"
    ManagedBy = "Terraform"
  }
}

# The AMI is built asynchronously. Use a data source to get the ID of the
# latest successful AMI built by the pipeline.
data "aws_imagebuilder_image" "latest_custom_ami" {
  arn = module.custom_karpenter_ami.image_pipeline_arn

  # This ensures the data source is refreshed when the pipeline is updated.
  depends_on = [module.custom_karpenter_ami]
}

output "latest_custom_ami_id" {
  description = "The ID of the latest custom AMI built by the pipeline."
  value       = data.aws_imagebuilder_image.latest_custom_ami.image_id
}
