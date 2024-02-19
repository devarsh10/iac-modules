# Default values for kratos-selfservice-ui-node.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

# -- Number of replicas in deployment
replicaCount: 1
# -- Number of revisions kept in history
revisionHistoryLimit: 5

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

## -- Application config
config:
  csrfCookieName: "__HOST-${auth_fqdn}-x-csrf-token"

## -- Service configuration
service:
  type: ClusterIP
  # -- The load balancer IP
  loadBalancerIP: ""
  nodePort: ""
  port: 80
  # -- The service port name. Useful to set a custom service port name if it must follow a scheme (e.g. Istio)
  name: http

## -- Secret configuration
secret:
  # -- switch to false to prevent creating the secret
  enabled: false
  # -- Provide custom name of existing secret, or custom name of secret to be created
  nameOverride: kratos-secret
  # nameOverride: "myCustomSecret"

## -- Ingress configration
ingress:
  enabled: false

## -- Deployment configuration
deployment:
  resources: {}
  #  We usually recommend not to specify default resources and to leave this as a conscious
  #  choice for the user. This also increases chances charts run on environments with little
  #  resources, such as Minikube. If you do want to specify resources, uncomment the following
  #  lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  #  limits:
  #    cpu: 100m
  #    memory: 128Mi
  #  requests:
  #    cpu: 100m
  #  memory: 128Mi

  # -- Array of extra envs to be passed to the deployment. Kubernetes format is expected
  # - name: FOO
  #   value: BAR
  extraEnv: []
  # -- If you want to mount external volume
  # For example, mount a secret containing Certificate root CA to verify database
  # TLS connection.
  extraVolumes: []
  # - name: my-volume
  #   secret:
  #     secretName: my-secret
  extraVolumeMounts: []
  # - name: my-volume
  #   mountPath: /etc/secrets/my-secret
  #   readOnly: true

  # -- Node labels for pod assignment.
  nodeSelector: {}
  # If you do want to specify node labels, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'annotations:'.
  #   foo: bar

  # -- Configure node tolerations.
  tolerations: []

  # -- Configure pod topologySpreadConstraints.
  topologySpreadConstraints: []
  # - maxSkew: 1
  #   topologyKey: topology.kubernetes.io/zone
  #   whenUnsatisfiable: DoNotSchedule
  #   labelSelector:
  #     matchLabels:
  #       app.kubernetes.io/name: kratos-selfservice-ui-node
  #       app.kubernetes.io/instance: kratos-selfservice-ui-node

  # -- Configure pod dnsConfig.
  dnsConfig: {}
  #   options:
  #     - name: "ndots"
  #       value: "1"

  labels: {}
  #      If you do want to specify additional labels, uncomment the following
  #      lines, adjust them as necessary, and remove the curly braces after 'labels:'.
  #      e.g.  type: app

  annotations: {}
  #      If you do want to specify annotations, uncomment the following
  #      lines, adjust them as necessary, and remove the curly braces after 'annotations:'.
  #      e.g.  sidecar.istio.io/rewriteAppHTTPProbers: "true"

  # https://github.com/kubernetes/kubernetes/issues/57601
  automountServiceAccountToken: false

affinity: {}

# -- Set this to ORY Kratos's Admin URL
kratosAdminUrl: "http://kratos-admin"

# -- Set this to ORY Kratos's public URL
kratosPublicUrl: "http://kratos-public"

# -- Set this to ORY Kratos's public URL accessible from the outside world.
kratosBrowserUrl: "https://${auth_fqdn}/kratos"

# -- The basePath
basePath: ""

# -- The jwksUrl
jwksUrl: "http://oathkeeper-api"

projectName: "SecureApp"

test:
  # -- use a busybox image from another repository
  busybox:
    repository: busybox
    tag: 1
