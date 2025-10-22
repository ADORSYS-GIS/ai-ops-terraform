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

# Default modules to apply if none specified
DEFAULT_MODULES=(
    "module.custom_karpenter_ami"
    "module.k_server_custom_ami"
    "module.eks"
    "module.kserve"
    "module.ai_gateway"
    "module.lmcache"
)

# Module to namespace mapping (for verification)
declare -A MODULE_NAMESPACES=(
    ["module.kserve"]="kserve"
    ["module.ai_gateway"]="envoy-ai-gateway-system envoy-gateway-system"
    ["module.lmcache"]="redis-system lmcache"
)

# Initialize arrays
declare -a MODULES_TO_APPLY=()
declare -a CUSTOM_NAMESPACES=()

# Flag to check if we should only verify namespaces
VERIFY_ONLY=false

# Function to display usage information
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --modules MODULES   Comma-separated list of modules to apply (default: ${DEFAULT_MODULES[*]})"
    echo "  --namespaces NS     Comma-separated list of namespaces to verify (verify-only mode)"
    echo "  --auto-approve      Automatically approve all actions without prompting"
    echo "  --help              Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  TF_MODULES          Comma-separated list of modules (same as --modules)"
    echo "  TF_NAMESPACES       Comma-separated list of namespaces (same as --namespaces)"
    echo "  AUTO_APPROVE        Set to 'true' to auto-approve all actions"
    echo ""
    echo "Examples:"
    echo "  $0 --modules module.kserve,module.ai_gateway"
    echo "  $0 --namespaces kserve,envoy-ai-gateway-system"
    echo "  TF_MODULES=module.kserve,module.ai_gateway $0"
    echo ""
    echo "Available modules:"
    for module in "${DEFAULT_MODULES[@]}"; do
        echo "  - $module"
    done
    exit 0
}

# Parse command line arguments (SINGLE PASS)
while [[ $# -gt 0 ]]; do
    case "$1" in
        --modules)
            if [ -z "$2" ]; then
                echo "Error: --modules requires a value"
                show_usage
            fi
            IFS=',' read -r -a MODULES_TO_APPLY <<< "$2"
            shift 2
            ;;
        --namespaces)
            if [ -z "$2" ]; then
                echo "Error: --namespaces requires a value"
                show_usage
            fi
            IFS=',' read -r -a CUSTOM_NAMESPACES <<< "$2"
            VERIFY_ONLY=true
            shift 2
            ;;
        --auto-approve)
            AUTO_APPROVE=true
            shift
            ;;
        --help)
            show_usage
            ;;
        -*)
            echo "Error: Unknown option: $1"
            show_usage
            ;;
        *)
            echo "Error: Unexpected argument: $1"
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
check_command "kubectl"

# Only check for terraform and helm if not in verify-only mode
if [ "$VERIFY_ONLY" = false ]; then
    check_command "terraform"
    check_command "helm"
fi

echo "All pre-requisite commands found."
echo ""

# Check for environment variables (only if not already set by CLI args)
if [ ${#MODULES_TO_APPLY[@]} -eq 0 ] && [ -n "$TF_MODULES" ]; then
    IFS=',' read -r -a MODULES_TO_APPLY <<< "$TF_MODULES"
fi

if [ ${#CUSTOM_NAMESPACES[@]} -eq 0 ] && [ -n "$TF_NAMESPACES" ]; then
    IFS=',' read -r -a CUSTOM_NAMESPACES <<< "$TF_NAMESPACES"
fi

# Use default modules if still empty
if [ ${#MODULES_TO_APPLY[@]} -eq 0 ]; then
    MODULES_TO_APPLY=("${DEFAULT_MODULES[@]}")
fi

# Get unique namespaces for verification
if [ ${#CUSTOM_NAMESPACES[@]} -gt 0 ]; then
    # Use custom namespaces if provided
    NAMESPACES=("${CUSTOM_NAMESPACES[@]}")
else
    # Auto-detect namespaces from selected modules
    declare -A unique_ns
    for module in "${MODULES_TO_APPLY[@]}"; do
        if [ -n "${MODULE_NAMESPACES[$module]}" ]; then
            for ns in ${MODULE_NAMESPACES[$module]}; do
                unique_ns["$ns"]=1
            done
        fi
    done
    NAMESPACES=("${!unique_ns[@]}")
fi

# If only verifying namespaces, skip all Terraform operations
if [ "$VERIFY_ONLY" = true ]; then
    echo "--- Verify-Only Mode: Checking Kubernetes Resources ---"
    echo "Skipping Terraform operations. Only verifying resources in specified namespaces."
    echo ""
    
    verify_kubernetes_resources() {
        if [ ${#NAMESPACES[@]} -eq 0 ]; then
            echo "No namespaces specified. Please provide namespaces with --namespaces option."
            exit 1
        fi

        echo "--- Verifying Kubernetes Resources ---"
        for ns in "${NAMESPACES[@]}"; do
            echo "========================================"
            echo "Namespace: $ns"
            echo "========================================"
            
            echo ""
            echo "→ Deployments:"
            kubectl get deployments -n "$ns" 2>/dev/null || echo "  No deployments found or namespace doesn't exist: $ns"
            
            echo ""
            echo "→ StatefulSets:"
            kubectl get statefulsets -n "$ns" 2>/dev/null || echo "  No statefulsets found or namespace doesn't exist: $ns"
            
            echo ""
            echo "→ DaemonSets:"
            kubectl get daemonsets -n "$ns" 2>/dev/null || echo "  No daemonsets found or namespace doesn't exist: $ns"
            
            echo ""
            echo "→ Services:"
            kubectl get services -n "$ns" 2>/dev/null || echo "  No services found or namespace doesn't exist: $ns"
            
            echo ""
            echo "→ Pods:"
            kubectl get pods -n "$ns" -o wide 2>/dev/null || echo "  No pods found or namespace doesn't exist: $ns"
            
            echo ""
            echo "→ ConfigMaps:"
            kubectl get configmaps -n "$ns" 2>/dev/null || echo "  No configmaps found or namespace doesn't exist: $ns"
            
            echo ""
            echo "→ Secrets:"
            kubectl get secrets -n "$ns" 2>/dev/null || echo "  No secrets found or namespace doesn't exist: $ns"
            
            echo ""
            echo "→ Ingresses:"
            kubectl get ingresses -n "$ns" 2>/dev/null || echo "  No ingresses found or namespace doesn't exist: $ns"
            
            echo ""
            echo "========================================"
            echo ""
        done
        echo "Verification complete."
    }
    
    verify_kubernetes_resources
    echo "--- Script Finished (Verify-Only Mode) ---"
    exit 0
fi

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
echo "  - Karpenter - for dynamic node provisioning"
echo "  - KServe (via module.kserve) - for serving machine learning models."
echo "  - AI Gateway (via module.ai_gateway) - for routing and managing API traffic."
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
echo ""

# --- Terraform Plan ---
echo "--- Generating Terraform Plan ---"
echo "Creating a consolidated plan for all specified target modules. Please review the proposed changes carefully."

# Construct the -target arguments dynamically for the plan
PLAN_TARGET_ARGS=""
for module_name in "${MODULES_TO_APPLY[@]}"; do
    PLAN_TARGET_ARGS+=" -target=$module_name"
done

# Execute terraform plan with all targets and optional tfvars file
# Use eval to properly expand the arguments
eval terraform plan $PLAN_TARGET_ARGS $TFVARS_FILE || handle_error "Terraform plan failed."
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
    # Use eval to properly handle variable expansion
    eval terraform apply $TF_AUTO_APPROVE -target="$module_name" $TFVARS_FILE || handle_error "Terraform apply failed for $module_name."
    echo "Successfully applied changes for $module_name."
    echo "--------------------------------------------------"
    echo ""
done

# --- Post-apply Resource Verification ---
verify_kubernetes_resources() {
    if [ ${#NAMESPACES[@]} -eq 0 ]; then
        echo "No namespaces to verify. Skipping resource verification."
        return
    fi

    echo "--- Verifying Deployed Kubernetes Resources ---"
    for ns in "${NAMESPACES[@]}"; do
        echo "Checking Kubernetes resources in namespace: $ns"
        echo "  Deployments:"
        kubectl get deployments -n "$ns" 2>/dev/null || echo "    No deployments found or namespace doesn't exist: $ns."
        echo "  Services:"
        kubectl get services -n "$ns" 2>/dev/null || echo "    No services found or namespace doesn't exist: $ns."
        echo "  Pods:"
        kubectl get pods -n "$ns" 2>/dev/null || echo "    No pods found or namespace doesn't exist: $ns."
        echo ""
    done
    echo "Verification complete."
}

verify_kubernetes_resources

echo "--- All Specified Terraform Modules Applied Successfully ---"
echo "Please verify the deployed resources in your AWS account and Kubernetes cluster."
echo ""
echo "--- Script Finished ---"