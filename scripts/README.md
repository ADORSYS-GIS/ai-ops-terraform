# Scripts Directory

This directory contains utility scripts for managing the AI Ops Terraform infrastructure.

## Available Scripts

### 1. `apply_kivoyo_eks.sh`

This script automates the targeted application of Terraform changes for specific modules within the Kivoyo EKS Cluster infrastructure. It supports selective module deployment and Kubernetes resource verification.

#### Prerequisites
- Terraform
- kubectl
- helm (only required for module deployment)
- AWS CLI configured with appropriate credentials

#### Key Features
- **Selective Module Deployment**: Target specific Terraform modules for deployment
- **Verify-Only Mode**: Check Kubernetes resources without making any changes
- **Auto-approval**: Run in non-interactive mode for CI/CD pipelines
- **Environment Variable Support**: Configure options via environment variables
- **Comprehensive Verification**: Detailed Kubernetes resource inspection

#### Usage
```bash
# Interactive mode (default):
./scripts/apply_kivoyo_eks.sh

# Auto-approve mode (non-interactive):
./scripts/apply_kivoyo_eks.sh --auto-approve

# Target specific modules:
./scripts/apply_kivoyo_eks.sh --modules module.kserve,module.ai_gateway

# Verify Kubernetes resources only:
./scripts/apply_kivoyo_eks.sh --namespaces kserve,envoy-ai-gateway-system

# Show help and available modules:
./scripts/apply_kivoyo_eks.sh --help
```

#### Environment Variables
- `TF_MODULES`: Comma-separated list of modules to apply (same as --modules)
- `TF_NAMESPACES`: Comma-separated list of namespaces to verify (same as --namespaces)
- `AUTO_APPROVE`: Set to 'true' to auto-approve all actions

#### Available Modules
- `module.custom_karpenter_ami`: Custom AMI for Karpenter nodes
- `module.k_server_custom_ami`: Custom AMI for k_server node group
- `module.eks`: EKS cluster and node groups
- `module.kserve`: KServe for model serving
- `module.ai_gateway`: AI Gateway for API traffic management
- `module.lmcache`: LM Cache for large model inferences

### 2. `k_server_customization_script.sh`

This script is used for customizing the AMI for the k_server node group.

#### Usage
This script is automatically used by the Terraform configuration during the AMI build process. Manual execution is typically not required. The script is called by the `custom_karpenter_ami` and `k_server_custom_ami` modules during the AMI build process.

## Directory Structure

```
scripts/
├── README.md                  # This documentation file
├── apply_kivoyo_eks.sh       # Main deployment script with module targeting
└── k_server_customization_script.sh  # AMI customization script (used during AMI builds)
```

## Notes
- Make scripts executable before use:
  ```bash
  chmod +x scripts/*.sh
  ```
- Required permissions:
  - AWS IAM permissions for EKS cluster management
  - kubectl access to the target cluster
  - Terraform state access
  - Helm for certain module deployments
- The scripts should be run from the project root directory
- For production use, consider setting up appropriate IAM roles and policies
- The verify-only mode (`--namespaces`) can be used to check cluster health without making changes
