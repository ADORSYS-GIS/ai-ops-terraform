module "karpenter" {
  source                = "terraform-aws-modules/eks/aws//modules/karpenter"
  version               = "~> 21.3"
  cluster_name          = var.cluster_name
  enable_v1_permissions = true
  create_pod_identity_association = true
  create_node_iam_role            = false
  node_iam_role_arn               = var.node_iam_role_arn
  create_access_entry             = false
  tags                            = var.tags
}

module "karpenter-helm" {
  source  = "blackbird-cloud/deployment/helm"
  version = "~> 1.0"

  name             = "karpenter"
  namespace        = var.namespace
  create_namespace = var.create_namespace

  repository    = "oci://public.ecr.aws/karpenter"
  chart         = "karpenter"
  chart_version = var.chart_version

  values = [
    templatefile("${path.module}/files/karpenter.yaml", {
      clusterName       = var.cluster_name
      clusterEndpoint   = var.cluster_endpoint
      interruptionQueue = module.karpenter.queue_name
      instanceProfile   = var.instance_profile
      customAmiId       = var.custom_ami_id
    })
  ]

  cleanup_on_fail = false
  wait            = true
}