output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL"
  value       = module.eks.cluster_oidc_issuer_url
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

output "next_steps" {
  description = "Next steps after cluster creation"
  value       = <<-EOT
  
  ✅ Base EKS Cluster Created Successfully!
  
  Next Steps:
  
  1. Configure kubectl:
     aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}
  
  2. Verify cluster access:
     kubectl get nodes
     kubectl get pods -A
  
  3. Run the apply_kivoyo_eks.sh script to deploy modules:
     cd /path/to/ai-ops-terraform
     ./apply_kivoyo_eks.sh --auto-approve
  
  4. Or deploy specific modules:
     ./apply_kivoyo_eks.sh --modules module.kserve,module.ai_gateway
  
  EOT
}