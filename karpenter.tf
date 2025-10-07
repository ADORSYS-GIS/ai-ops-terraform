module "karpenter" {
  source = "./modules/karpenter"

  cluster_name       = module.eks.cluster_name
  cluster_endpoint   = module.eks.cluster_endpoint
  node_iam_role_arn  = module.eks.eks_managed_node_groups["knative-ng"].iam_role_arn
  instance_profile   = module.eks.eks_managed_node_groups["knative-ng"].instance_profile_name
  custom_ami_id      = module.custom_karpenter_ami.ami_id
  namespace          = "karpenter"
  create_namespace   = true
  chart_version      = "1.4.0"

  tags = merge(
    local.tags,
    {}
  )
}