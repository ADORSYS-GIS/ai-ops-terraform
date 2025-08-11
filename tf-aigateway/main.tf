terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

provider "kubernetes" {
  config_path = var.kube_config_path
}

provider "kubectl" {
  config_path = var.kube_config_path
}

resource "helm_release" "ai_gateway_crds" {
  name             = "aieg-crd"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "ai-gateway-crds-helm"
  version          = var.chart_version
  namespace        = var.ai_gateway_namespace
  create_namespace = true
}

resource "helm_release" "ai_gateway" {
  name             = "aieg"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "ai-gateway-helm"
  version          = var.chart_version
  namespace        = var.ai_gateway_namespace
  create_namespace = true
  skip_crds        = true
  depends_on       = [helm_release.ai_gateway_crds]
}

resource "helm_release" "envoy_gateway" {
  name             = "eg"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "gateway-helm"
  version          = var.chart_version
  namespace        = var.envoy_gateway_namespace
  create_namespace = true
  depends_on       = [helm_release.ai_gateway]
}

data "http" "config_yaml" {
  url = var.config_yaml_url
}

data "http" "rbac_yaml" {
  url = var.rbac_yaml_url
}

resource "kubectl_manifest" "envoy_gateway_config" {
  yaml_body = data.http.config_yaml.body
  depends_on = [
    data.http.config_yaml,
    helm_release.envoy_gateway,
  ]
}

resource "kubectl_manifest" "redis_namespace" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Namespace
    metadata:
      name: redis-system
  YAML

  depends_on = [ helm_release.envoy_gateway ]
}

resource "kubectl_manifest" "redis_service" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: redis
      namespace: redis-system
      labels:
        app: redis
    spec:
      ports:
        - name: redis
          port: 6379
      selector:
        app: redis
  YAML

  depends_on = [ kubectl_manifest.redis_namespace ]
}

resource "kubectl_manifest" "redis_deployment" {
  yaml_body = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: redis
      namespace: redis-system
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: redis
      template:
        metadata:
          labels:
            app: redis
        spec:
          containers:
            - image: redis:alpine
              imagePullPolicy: IfNotPresent
              name: redis
              ports:
                - name: redis
                  containerPort: 6379
          restartPolicy: Always
  YAML

  server_side_apply = true
  field_manager     = "terraform"

  depends_on = [ kubectl_manifest.redis_service, kubectl_manifest.redis_namespace  ] 
}


resource "kubectl_manifest" "envoy_gateway_rbac" {
  yaml_body = data.http.rbac_yaml.body
  depends_on = [
    data.http.rbac_yaml,
    kubectl_manifest.envoy_gateway_config,
  ]
}


