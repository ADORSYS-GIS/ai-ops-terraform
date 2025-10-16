#!/bin/bash

# Script: apply_kivoyo_eks.sh
# Description: This script automates the targeted application of Terraform changes
#              for specific modules within the Kivoyo EKS Cluster infrastructure.
#              It is designed to install or update core components including
#              Envoy (via AI Gateway), KServe, LMCache, and the EKS cluster itself,
#              with a focus on custom AMIs for Karpenter and the 'k_server' node group.
#              ArgoCD is assumed to be pre-existing and is not managed by this script.

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to display error messages and exit
handle_error() {
    echo "ERROR: $1" >&2
    exit 1
}

# --- Configuration ---
# Define the Terraform modules to be applied.
# The order is important due to dependencies:
# - Custom AMI modules should be applied before the EKS module that consumes them.
# - Core services like KServe and AI Gateway can be applied once the EKS cluster is ready.
MODULES_TO_APPLY=(
    "module.custom_karpenter_ami" # Ensures the Karpenter custom AMI is built/updated first.
    "module.k_server_custom_ami"  # Ensures the k_server custom AMI is built/updated first.
    "module.eks"                  # Applies EKS cluster changes, including node groups using custom AMIs.
    "module.kserve"               # Deploys KServe components onto the EKS cluster.
    "module.ai_gateway"           # Deploys Envoy/AI Gateway components.
    "module.lmcache"              # Deploys LMCache components.
)

# --- Pre-apply Checks and Information ---
echo "--- Terraform Apply Script for Kivoyo EKS Cluster ---"
echo ""
echo "This script will perform a targeted Terraform apply for the following modules:"
for module in "${MODULES_TO_APPLY[@]}"; do
    echo "- $module"
done
echo ""
echo "Specifically, the following infrastructure components will be installed/updated:"
echo "  - Custom Karpenter AMI (via module.custom_karpenter_ami)"
echo "  - Custom k_server AMI (via module.k_server_custom_ami)"
echo "  - EKS Cluster (module.eks), including the 'k_server' node group which will use the custom AMI."
echo "  - KServe (via module.kserve) - for serving machine learning models."
echo "  - AI Gateway (via module.ai_gateway) - likely for routing and managing API traffic."
echo "  - LMCache (via module.lmcache) - for caching large model inferences."
echo ""
echo "Note: ArgoCD is assumed to be already deployed and will not be managed by this script."
echo "The order of application is crucial: Custom AMI modules are applied first to ensure"
echo "their outputs (AMI IDs) are available before the EKS module attempts to use them"
echo "for node group provisioning."
echo ""

read -p "This script will initialize Terraform, generate a plan, and then apply changes to the Kivoyo EKS Cluster. Do you want to proceed? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Operation cancelled by user."
    exit 0
fi

# --- Terraform Initialization ---
echo "--- Initializing Terraform ---"
echo "Running 'terraform init' to configure the backend and plugins..."
terraform init \
    -backend-config="bucket=kivoyo-terraform-state" \
    -backend-config="key=kivoyo-eks.tfstate" \
    -backend-config="region=eu-west-1" || handle_error "Terraform initialization failed."
echo "Terraform initialized successfully."
echo ""

# --- Terraform Plan ---
echo "--- Generating Terraform Plan ---"
echo "Creating a consolidated plan for all specified target modules. Please review the proposed changes carefully."
# Construct the -target arguments dynamically for the plan
PLAN_TARGET_ARGS=""
for module_name in "${MODULES_TO_APPLY[@]}"; do
    PLAN_TARGET_ARGS+=" -target=$module_name"
done

# Execute terraform plan with all targets
terraform plan $PLAN_TARGET_ARGS || handle_error "Terraform plan failed."
echo "Terraform plan generated. Please review the changes above before proceeding with the apply."
echo ""

read -p "Do you want to apply these changes? (yes/no): " APPLY_CONFIRM
if [[ "$APPLY_CONFIRM" != "yes" ]]; then
    echo "Apply operation cancelled by user."
    exit 0
fi

# --- Selective Terraform Apply ---
echo "--- Starting Selective Terraform Apply ---"
echo "Applying changes for each specified module sequentially."
echo "Each module will be applied individually using the '-target' flag."
echo "You will be prompted for confirmation for each module unless '-auto-approve' is used (which is currently disabled)."
echo ""

for module_name in "${MODULES_TO_APPLY[@]}"; do
    echo "Applying changes for module: $module_name..."
    # Removed -auto-approve to allow for manual confirmation during apply
    terraform apply -target="$module_name" || handle_error "Terraform apply failed for $module_name."
    echo "Successfully applied changes for $module_name."
    echo "--------------------------------------------------"
    echo ""
done

echo "--- All Specified Terraform Modules Applied Successfully ---"
echo "Please verify the deployed resources in your AWS account and Kubernetes cluster."
echo ""
echo "--- Script Finished ---"