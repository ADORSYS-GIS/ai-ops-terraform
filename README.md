# Terraform Module: KServe Installer

This module installs [KServe](https://kserve.github.io/website/) into a Kubernetes cluster using Helm via Terraform. It's designed to work with local k3s clusters.

## 🧩 Requirements

- Kubernetes cluster (e.g., k3s)
- Terraform >= 1.9.8
- Helm provider >= 2.0
- Kubernetes provider >= 2.0
- kubectl CLI

## 🔧 Prerequisites

Before running this module, ensure you have:

1. A running k3s cluster
2. kubectl configured to access your k3s cluster
3. Appropriate permissions to create namespaces and resources in the cluster

## 🚀 Usage

```hcl
module "kserve" {
  source = "./path/to/this/module"

  # Kubernetes connection details
  kube_host     = "https://localhost:6443"
  kube_token    = "your-k3s-token"
  kube_ca_cert  = "base64-encoded-ca-cert"

  # Optional variables
  kserve_chart_version   = "0.11.2"
  kserve_version         = "v0.15.2"
  tls_certificate_name   = "kserve-tls-certificate"  # Optional for HTTPS
}
```

Create a `terraform.tfvars` file with your specific values:

```hcl
kube_host    = "https://localhost:6443"
kube_token   = "your-k3s-token"
kube_ca_cert = "base64-encoded-ca-cert"
```

Then run:

```bash
terraform init
terraform apply
```

## 📥 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| kube_host | Kubernetes API server endpoint (for k3s, typically https://localhost:6443) | `string` | `"https://localhost:6443"` | no |
| kube_token | Kubernetes auth token (for k3s, can be found in /var/lib/rancher/k3s/server/token) | `string` | `""` | no |
| kube_ca_cert | Base64 encoded certificate for the Kubernetes cluster (for k3s, can be found in /var/lib/rancher/k3s/server/tls/client-ca.crt) | `string` | `""` | no |
| kube_client_cert | Base64 encoded client certificate for Kubernetes authentication | `string` | `""` | no |
| kube_client_key | Base64 encoded client key for Kubernetes authentication | `string` | `""` | no |
| kserve_chart_version | KServe Helm chart version | `string` | `"0.11.2"` | no |
| kserve_version | KServe version | `string` | `"v0.15.2"` | no |
| tls_certificate_name | Name of the TLS certificate secret for the HTTPS listener | `string` | `""` | no |

## 📤 Outputs

| Name | Description |
|------|-------------|
| kserve_namespace | The name of the Kubernetes namespace where KServe is installed |

## 🏗️ Implementation Details

This module performs the following actions:

1. Creates a `kserve` namespace in the Kubernetes cluster
2. Installs cert-manager for certificate management
3. Installs the Gateway API network controller
4. Creates GatewayClass and Gateway resources for ingress
5. Installs KServe CRDs via Helm
6. Installs KServe via Helm with default values from `values/kserve-values.yaml`

The module uses the following Helm charts from the KServe project:
- `kserve-crd` for Custom Resource Definitions
- `kserve` for the main KServe components

## 🔐 TLS Configuration

To enable HTTPS for the KServe gateway, you need to provide a TLS certificate. You can either:

1. Create a self-signed certificate using cert-manager (recommended for development):
   ```bash
   # Install cert-manager if not already installed
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
   
   # Create a self-signed certificate
   kubectl apply -f - <<EOF
   apiVersion: cert-manager.io/v1
   kind: Issuer
   metadata:
     name: selfsigned-issuer
     namespace: kserve
   spec:
     selfSigned: {}
   ---
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: kserve-tls-certificate
     namespace: kserve
   spec:
     secretName: kserve-tls-certificate
     issuerRef:
       name: selfsigned-issuer
   EOF
   ```

2. Use an existing TLS certificate:
   If you already have a TLS certificate, you can create a Kubernetes secret with it:
   ```bash
   kubectl create secret tls kserve-tls-certificate \
     --cert=path/to/cert.crt \
     --key=path/to/cert.key \
     --namespace kserve
   ```

After creating the certificate, set the `tls_certificate_name` variable in your `terraform.tfvars` file to the name of the secret (e.g., `kserve-tls-certificate`).

If you don't need HTTPS, you can leave `tls_certificate_name` as an empty string, and the HTTPS listener will be disabled.

## 🧪 Testing

After deploying the KServe module, you can verify that the installation was successful by running the following tests:

### 1. Check the KServe Namespace and Pods

Run:

```bash
kubectl get ns kserve
kubectl get pods -n kserve
```

You should see:

- A namespace `kserve`
- Pods like:
  - `kserve-controller-manager`
  - `kserve-webhook-server`
  - `kserve-storage-initializer` (optional)
  - Any other components specified in the chart

Look for pods in `Running` or `Completed` status.

### 2. Check that KServe CRDs are installed

Run:

```bash
kubectl get crds | grep kserve
```

Expected output includes CRDs like:

- `inferenceservices.serving.kserve.io`
- `trainedmodels.serving.kserve.io`
- `predictors.serving.kserve.io`

And others depending on version.

To see all the KServe-related CRDs:

```bash
kubectl get crds | grep serving.kserve.io
```

### 3. Check Gateway and GatewayClass Resources

Check GatewayClass:

```bash
kubectl get gatewayclass
```

You should see:

```
NAME     CONTROLLER                                 AGE
envoy    gateway.envoyproxy.io/gatewayclass-controller   ...
```

Check Gateway:

```bash
kubectl get gateway -n kserve
```

You should see:

```
NAME                     CLASS   ADDRESS     ...
kserve-ingress-gateway   envoy   <pending or IP>
```

- If ADDRESS is `<pending>`, it may be waiting for the Envoy Gateway controller to provision a load balancer or service.

### 4. Check Helm Releases

Check that both Helm charts were deployed:

```bash
helm list -n kserve
```

You should see:

- `kserve-crd`
- `kserve`

### 5. Deploy a Test InferenceService (Optional)

If everything above looks good, you can deploy a test model to verify KServe works:
Example: Deploy sklearn-iris

```bash
cat <<EOF | kubectl apply -f -
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: sklearn-iris
  namespace: kserve
spec:
  predictor:
    sklearn:
      storageUri: "gs://kfserving-examples/models/sklearn/iris"
EOF
```

Then:

```bash
kubectl get inferenceservice -n kserve
```

You should see:

```
NAME           URL                                      READY   ...
sklearn-iris   http://<some-url>                        True    ...
```

- If READY is True, then KServe is functioning properly.
