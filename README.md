# AI Gateway and Envoy Gateway Terraform Configuration

This repository contains Terraform configuration for deploying AI Gateway and Envoy Gateway on a Kubernetes cluster.

## Architecture Overview

This configuration deploys the following components:
1. AI Gateway CRDs
2. AI Gateway Helm chart
3. Envoy Gateway Helm chart
4. Required Kubernetes resources (Redis config, Envoy Gateway config, RBAC rules)
5. Deployment restart for Envoy Gateway

## File Structure

The Terraform configuration has been split into multiple files for better organization:

- `terraform.tf` - Terraform configuration block and module declaration
- `providers.tf` - Provider configurations for Helm and Kubernetes
- `variables.tf` - Variable definitions (kubeconfig path)
- `tf-aigateway/` - Sub-module containing all Envoy AI Gateway resources
  - `main.tf` - Main module file with all Envoy AI Gateway resources
  - `variables.tf` - Module-specific variables
  - `outputs.tf` - Module outputs
- `outputs.tf` - Output definitions (references module outputs)

## Prerequisites

- Terraform 1.0+
- Helm 3+
- Kubernetes cluster with kubectl configured
- Appropriate permissions for deploying resources

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Apply the configuration:
   ```bash
   terraform apply
   ```

3. (Optional) Override the kubeconfig path:
   ```bash
   terraform apply -var="kubeconfig=/path/to/your/kubeconfig"
   ```

## Module Structure

The Envoy AI Gateway deployment is now encapsulated in a Terraform sub-module located in the `tf-aigateway/` directory. This module handles:
- Installation of AI Gateway CRDs
- Installation of AI Gateway Helm chart
- Installation of Envoy Gateway Helm chart
- Application of required Kubernetes resources
- Restart of Envoy Gateway deployment

## Variables

- `kubeconfig` (default: "~/.kube/config") - Path to kubeconfig file for Kubernetes access

## Outputs

- `envoy_gateway_release_name` - Name of the deployed Envoy Gateway Helm release
- `ai_gateway_release_name` - Name of the deployed AI Gateway Helm release
- `ai_gateway_crds_release_name` - Name of the deployed AI Gateway CRDs Helm release

## Notes

The configuration uses Helm charts from the Envoy Proxy OCI registry and applies Kubernetes manifests from the AI Gateway repository.