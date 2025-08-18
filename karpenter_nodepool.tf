resource "kubernetes_manifest" "ec2_node_class" {
  manifest = {
    "apiVersion" = "karpenter.k8s.aws/v1beta1"
    "kind"       = "EC2NodeClass"
    "metadata" = {
      "name" = "custom-ami-node-class"
    }
    "spec" = {
      "amiFamily" = "Custom"
      "amiSelectorTerms" = [
        {
          "id" = data.aws_imagebuilder_image.latest_custom_ami.image_id
        }
      ]
      "role" = module.eks.eks_managed_node_groups["knative-ng"].iam_role_arn
      "subnetSelectorTerms" = [
        {
          "tags" = {
            "karpenter.sh/discovery" = local.eks_name
          }
        }
      ]
      "securityGroupSelectorTerms" = [
        {
          "tags" = {
            "aws:eks:cluster-name" = local.eks_name
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "default_node_pool" {
  manifest = {
    "apiVersion" = "karpenter.sh/v1beta1"
    "kind"       = "NodePool"
    "metadata" = {
      "name" = "default"
    }
    "spec" = {
      "disruption" = {
        "consolidationPolicy" = "WhenUnderutilized"
        "expireAfter"         = "720h" # 30 days
      }
      "template" = {
        "metadata" = {}
        "spec" = {
          "nodeClassRef" = {
            "name" = kubernetes_manifest.ec2_node_class.manifest.metadata.name
          }
          "requirements" = [
            {
              "key"      = "karpenter.sh/capacity-type"
              "operator" = "In"
              "values"   = ["on-demand", "spot"]
            },
            {
              "key"      = "karpenter.k8s.aws/instance-category"
              "operator" = "In"
              "values"   = ["c", "m", "r"]
            },
            {
              "key"      = "karpenter.k8s.aws/instance-generation"
              "operator" = "Gt"
              "values"   = ["2"]
            }
          ]
        }
      }
    }
  }
}
