# Scripts Directory

This directory contains utility scripts for managing the AI Ops Terraform infrastructure.

## Available Scripts

### 1. `apply_kivoyo_eks.sh`

This script automates the targeted application of Terraform changes for specific modules within the Kivoyo EKS Cluster infrastructure.

#### Prerequisites
- Terraform
- kubectl
- helm
- AWS CLI configured with appropriate credentials

#### Usage
```bash
# Interactive mode (default):
./scripts/apply_kivoyo_eks.sh

# Auto-approve mode/ non-interactive mode:
./scripts/apply_kivoyo_eks.sh --auto-approve

# Show help:
./scripts/apply_kivoyo_eks.sh --help
```

### 2. `k_server_customization_script.sh`

This script is used for customizing the AMI for the k_server node group.

#### Usage
This script is automatically used by the Terraform configuration during the AMI build process. Manual execution is typically not required.

## Directory Structure

```
scripts/
├── README.md                  # This file
├── apply_kivoyo_eks.sh       # Main deployment script
└── k_server_customization_script.sh  # AMI customization script
```

## Notes
- All scripts should be made executable before use:
  ```bash
  chmod +x scripts/*.sh
  ```
- Ensure you have the necessary permissions to execute the scripts and access the required AWS resources.
- The scripts assume they are being run from the project root directory.
