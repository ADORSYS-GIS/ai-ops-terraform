data "aws_region" "current" {}

data "aws_ami" "eks_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.base_ami_version}-v*"]
  }
}

locals {
  name_prefix = "${var.ami_name}-ami-builder"
  tags = merge(var.tags, {
    Name = local.name_prefix
  })
}

# IAM Role for EC2 Image Builder
resource "aws_iam_role" "image_builder" {
  name = "${local.name_prefix}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = local.tags
}

resource "aws_iam_instance_profile" "image_builder" {
  name = "${local.name_prefix}-profile"
  role = aws_iam_role.image_builder.name
}

resource "aws_iam_role_policy_attachment" "image_builder_ec2_container_registry_read_only" {
  role       = aws_iam_role.image_builder.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
}

resource "aws_iam_role_policy_attachment" "image_builder_s3" {
  role       = aws_iam_role.image_builder.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# EC2 Image Builder Recipe
resource "aws_imagebuilder_image_recipe" "this" {
  name              = "${local.name_prefix}-recipe"
  parent_image      = data.aws_ami.eks_optimized.id
  version           = var.component_version
  working_directory = "/tmp"

  component {
    component_arn = "arn:aws:imagebuilder:${data.aws_region.current.name}:aws:component/update-linux/x.x.x"
  }

  tags = local.tags
}

# EC2 Image Builder Infrastructure Configuration
resource "aws_imagebuilder_infrastructure_configuration" "this" {
  name                          = "${local.name_prefix}-infra-config"
  instance_types                = [var.build_instance_type]
  instance_profile_name         = aws_iam_instance_profile.image_builder.name
  subnet_id                     = var.subnet_id
  security_group_ids            = var.security_group_ids
  terminate_instance_on_failure = true
  tags                          = local.tags
}

# EC2 Image Builder Pipeline
resource "aws_imagebuilder_image_pipeline" "this" {
  name                             = "${local.name_prefix}-pipeline"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn

  schedule {
    schedule_expression                = var.pipeline_schedule_expression
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AFFECTED"
  }

  image_tests_configuration {
    timeout_minutes = 60
  }

  tags = local.tags
}

resource "aws_imagebuilder_image" "this" {
  name                             = "${local.name_prefix}-image"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn

  tags = local.tags
}
