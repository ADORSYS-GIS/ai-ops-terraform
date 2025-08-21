controller:
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 250m
      memory: 256Mi

webhook:
  enabled: true

storageInitializer:
  enabled: true

ingress:
  enabled: false  # Set true if you're integrating with Istio/Gateway
