#!/bin/bash

# Script: apply_kivoyo_eks.sh
# Description: This script automates the targeted application of Terraform changes
#              for specific modules within the Kivoyo EKS Cluster infrastructure.
#              It is designed to install or update core components including
#              Envoy (via AI Gateway), KServe, LMCache, and the EKS cluster itself,
#              with a focus on custom AMIs for Karpenter and the 'k_server' node group.
#              ArgoCD is assumed to be pre-existing and is not managed by this script.
#
# Usage:
#   Interactive mode (default): ./apply_kivoyo_eks.sh
#   Auto-approve mode:         ./apply_kivoyo_eks.sh --auto-approve
#   Help:                      ./apply_kivoyo_eks.sh --help

# Exit immediately if a command exits with a non-zero status.
set -e

# Default values
AUTO_APPROVE=${AUTO_APPROVE:-false}
TF_AUTO_APPROVE=""

# Function to display usage information
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --auto-approve     Automatically approve all actions without prompting"
    echo "  --help             Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  AUTO_APPROVE       Set to 'true' to auto-approve all actions"
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --auto-approve)
            AUTO_APPROVE=true
            shift
            ;;
        --help)
            show_usage
            ;;
        *)
            echo "Error: Unknown option: $1"
            show_usage
            ;;
    esac
done

# If auto-approve is enabled, set the Terraform auto-approve flag
if [ "$AUTO_APPROVE" = true ]; then
    TF_AUTO_APPROVE="-auto-approve"
fi

# Function to display error messages and exit
handle_error() {
    echo "ERROR: $1" >&2
    exit 1
}

# Function to prompt for confirmation
confirm() {
    if [ "$AUTO_APPROVE" = true ]; then
        echo "Auto-approval enabled. Proceeding with: $1"
        return 0
    fi

    read -p "$1 (yes/no): " CONFIRM
    if [[ "$CONFIRM" != "yes" ]]; then
        echo "Operation cancelled by user."
        exit 0
    fi
}

# --- Pre-requisite Checks ---
check_command() {
    if ! command -v "$1" &> /dev/null; then
        handle_error "$1 is not installed. Please install it to proceed."
    fi
}

echo "--- Performing Pre-requisite Checks ---"
check_command "terraform"
check_command "helm"
check_command "kubectl"
echo "All pre-requisite commands found."
echo ""

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

# Initial confirmation
confirm "This script will initialize Terraform, generate a plan, and then apply changes to the Kivoyo EKS Cluster. Do you want to proceed?"

# --- Terraform Initialization ---
echo "--- Initializing Terraform ---"
echo "Running 'terraform init' to configure the backend and plugins..."
terraform init || handle_error "Terraform initialization failed."
echo "Terraform initialized successfully."
echo ""

# Check for a .tfvars file
TFVARS_FILE=""
if [ -f "terraform.tfvars" ]; then
    TFVARS_FILE="-var-file=terraform.tfvars"
    echo "Using terraform.tfvars for variable input."
elif [ -f "terraform.tfvars.json" ]; then
    TFVARS_FILE="-var-file=terraform.tfvars.json"
    echo "Using terraform.tfvars.json for variable input."
else
    echo "No terraform.tfvars or terraform.tfvars.json found. Proceeding without -var-file."
fi

# --- Terraform Plan ---
echo "--- Generating Terraform Plan ---"
echo "Creating a consolidated plan for all specified target modules. Please review the proposed changes carefully."
# Construct the -target arguments dynamically for the plan
PLAN_TARGET_ARGS=""
for module_name in "${MODULES_TO_APPLY[@]}"; do
    PLAN_TARGET_ARGS+=" -target=$module_name"
done

# Execute terraform plan with all targets and optional tfvars file
terraform plan $PLAN_TARGET_ARGS $TFVARS_FILE || handle_error "Terraform plan failed."
echo "Terraform plan generated. Please review the changes above before proceeding with the apply."
echo ""

# Apply confirmation
confirm "Do you want to apply these changes?"

# --- Selective Terraform Apply ---
echo "--- Starting Selective Terraform Apply ---"
echo "Applying changes for each specified module sequentially."
echo "Each module will be applied individually using the '-target' flag."
if [ "$AUTO_APPROVE" = true ]; then
    echo "Auto-approval is enabled. All changes will be applied automatically."
else
    echo "You will be prompted for confirmation for each module unless '--auto-approve' is used."
fi
echo ""

for module_name in "${MODULES_TO_APPLY[@]}"; do
    echo "Applying changes for module: $module_name..."
    terraform apply $TF_AUTO_APPROVE -target="$module_name" $TFVARS_FILE || handle_error "Terraform apply failed for $module_name."
    echo "Successfully applied changes for $module_name."
    echo "--------------------------------------------------"
    echo ""
done

# --- Post-apply Resource Verification ---
echo "--- Verifying Deployed Kubernetes Resources ---"
verify_kubernetes_resources() {
    local namespaces=("kserve" "envoy-ai-gateway-system" "envoy-gateway-system" "redis-system" "lmcache")
    for ns in "${namespaces[@]}"; do
        echo "Checking Kubernetes resources in namespace: $ns"
        echo "  Deployments:"
        kubectl get deployments -n "$ns" || echo "    No deployments found in $ns or kubectl not configured."
        echo "  Services:"
        kubectl get services -n "$ns" || echo "    No services found in $ns or kubectl not configured."
        echo "  Pods:"
        kubectl get pods -n "$ns" || echo "    No pods found in $ns or kubectl not configured."
        echo ""
    done
    echo "Verification complete. Please manually inspect logs and resource statuses for full confirmation."
}

verify_kubernetes_resources

echo "--- All Specified Terraform Modules Applied Successfully ---"
echo "Please verify the deployed resources in your AWS account and Kubernetes cluster."
echo ""
echo "--- Script Finished ---"
