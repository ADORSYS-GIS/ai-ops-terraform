resources:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: envoy-gateway-config
      namespace: ${envoy_gateway_namespace}
    data:
      envoy-gateway.yaml: |
        apiVersion: gateway.envoyproxy.io/v1alpha1
        kind: EnvoyGateway
        gateway:
          controllerName: gateway.envoyproxy.io/gatewayclass-controller

        logging:
          level:
            default: info

        provider:
          type: Kubernetes
          kubernetes:
            rateLimitDeployment:
              patch:
                type: StrategicMerge
                value:
                  spec:
                    template:
                      spec:
                        containers:
                          - name: envoy-ratelimit
                            image: docker.io/envoyproxy/ratelimit:60d8e81b
                            imagePullPolicy: IfNotPresent

        extensionApis:
          enableEnvoyPatchPolicy: true
          enableBackend: true

        extensionManager:
          hooks:
            xdsTranslator:
              translation:
                listener:
                  includeAll: true
                route:
                  includeAll: true
                cluster:
                  includeAll: true
                secret:
                  includeAll: true
              post:
                - Translation
                - Cluster
                - Route
          service:
            fqdn:
              hostname: ai-gateway-controller.${ai_gateway_namespace}.svc.cluster.local
              port: 1063

%{ if enable_redis ~}
        rateLimit:
          backend:
            type: Redis
            redis:
              url: redis.${redis_namespace}.svc.cluster.local:6379
%{ endif ~}
