# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

## @section Global parameters
## Please, note that this will override the parameters, including dependencies, configured to use the global value
##
global:
  ## @param global.imageRegistry Global Docker image registry
  ##
  imageRegistry: ""
  ## @param global.imagePullSecrets Global Docker registry secret names as an array
  ## e.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  ## @param global.storageClass Global StorageClass for Persistent Volume(s)
  ##
  storageClass: ${resource.local_helm_config.pgsql_data.storage_class_name}

  postgresql:
    ## @param global.postgresql.auth.postgresPassword Password for the "postgres" admin user (overrides `auth.postgresPassword`)
    ## @param global.postgresql.auth.username Name for a custom user to create (overrides `auth.username`)
    ## @param global.postgresql.auth.password Password for the custom user to create (overrides `auth.password`)
    ## @param global.postgresql.auth.database Name for a custom database to create (overrides `auth.database`)
    ## @param global.postgresql.auth.existingSecret Name of existing secret to use for PostgreSQL credentials (overrides `auth.existingSecret`).
    ## @param global.postgresql.auth.secretKeys.adminPasswordKey Name of key in existing secret to use for PostgreSQL credentials (overrides `auth.secretKeys.adminPasswordKey`). Only used when `global.postgresql.auth.existingSecret` is set.
    ## @param global.postgresql.auth.secretKeys.userPasswordKey Name of key in existing secret to use for PostgreSQL credentials (overrides `auth.secretKeys.userPasswordKey`). Only used when `global.postgresql.auth.existingSecret` is set.
    ## @param global.postgresql.auth.secretKeys.replicationPasswordKey Name of key in existing secret to use for PostgreSQL credentials (overrides `auth.secretKeys.replicationPasswordKey`). Only used when `global.postgresql.auth.existingSecret` is set.
    ##
    auth:
      postgresPassword: "${resource.local_helm_config.pgsql_data.root_password}"
      username: ${resource.local_helm_config.pgsql_data.user}
      password: "${resource.local_helm_config.pgsql_data.user_password}"
      database: ${resource.local_helm_config.pgsql_data.database_name}
      existingSecret: "${resource.local_helm_config.pgsql_data.existing_secret}"
      secretKeys:
        adminPasswordKey: postgres-password
        userPasswordKey: password
        replicationPasswordKey: replication-password
    ## @param global.postgresql.service.ports.postgresql PostgreSQL service port (overrides `service.ports.postgresql`)
    ##
    service:
      ports:
        postgresql: ${resource.local_helm_config.pgsql_data.service_port}

## @section Common parameters
##

## @param kubeVersion Override Kubernetes version
##
kubeVersion: ""
## @param nameOverride String to partially override common.names.fullname template (will maintain the release name)
##
nameOverride: ${key}
## @param fullnameOverride String to fully override common.names.fullname template
##
fullnameOverride: ""
## @param clusterDomain Kubernetes Cluster Domain
##
clusterDomain: cluster.local
## @param extraDeploy Array of extra objects to deploy with the release (evaluated as a template)
##
extraDeploy: []
## @param commonLabels Add labels to all the deployed resources
##
commonLabels: {}
## @param commonAnnotations Add annotations to all the deployed resources
##
commonAnnotations: {}
## Enable diagnostic mode in the statefulset
##
diagnosticMode:
  ## @param diagnosticMode.enabled Enable diagnostic mode (all probes will be disabled and the command will be overridden)
  ##
  enabled: false
  ## @param diagnosticMode.command Command to override all containers in the statefulset
  ##
  command:
    - sleep
  ## @param diagnosticMode.args Args to override all containers in the statefulset
  ##
  args:
    - infinity

## @section PostgreSQL common parameters
##

## Bitnami PostgreSQL image version
## ref: https://hub.docker.com/r/bitnami/postgresql/tags/
## @param image.registry PostgreSQL image registry
## @param image.repository PostgreSQL image repository
## @param image.tag PostgreSQL image tag (immutable tags are recommended)
## @param image.digest PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
## @param image.pullPolicy PostgreSQL image pull policy
## @param image.pullSecrets Specify image pull secrets
## @param image.debug Specify if debug values should be set
##
image:
  registry: docker.io
  repository: bitnami/postgresql
  digest: ""
  ## Specify a imagePullPolicy
  ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
  ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  ##
  pullPolicy: IfNotPresent
  ## Optionally specify an array of imagePullSecrets.
  ## Secrets must be manually created in the namespace.
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
  ## Example:
  ## pullSecrets:
  ##   - myRegistryKeySecretName
  ##
  pullSecrets: []
  ## Set to true if you would like to see extra information on logs
  ##
  debug: false
## Authentication parameters
## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql#setting-the-root-password-on-first-run
## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql#creating-a-database-on-first-run
## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql#creating-a-database-user-on-first-run
##
auth:
  ## @param auth.enablePostgresUser Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user
  ##
  enablePostgresUser: true
  ## @param auth.postgresPassword Password for the "postgres" admin user. Ignored if `auth.existingSecret` is provided
  ##
  postgresPassword: ""
  ## @param auth.username Name for a custom user to create
  ##
  username: ""
  ## @param auth.password Password for the custom user to create. Ignored if `auth.existingSecret` is provided
  ##
  password: ""
  ## @param auth.database Name for a custom database to create
  ##
  database: ""
  ## @param auth.replicationUsername Name of the replication user
  ##
  replicationUsername: repl_user
  ## @param auth.replicationPassword Password for the replication user. Ignored if `auth.existingSecret` is provided
  ##
  replicationPassword: "${resource.local_helm_config.pgsql_data.root_password}"
  ## @param auth.existingSecret Name of existing secret to use for PostgreSQL credentials. `auth.postgresPassword`, `auth.password`, and `auth.replicationPassword` will be ignored and picked up from this secret. The secret might also contains the key `ldap-password` if LDAP is enabled. `ldap.bind_password` will be ignored and picked from this secret in this case.
  ##
  existingSecret: ""
  ## @param auth.secretKeys.adminPasswordKey Name of key in existing secret to use for PostgreSQL credentials. Only used when `auth.existingSecret` is set.
  ## @param auth.secretKeys.userPasswordKey Name of key in existing secret to use for PostgreSQL credentials. Only used when `auth.existingSecret` is set.
  ## @param auth.secretKeys.replicationPasswordKey Name of key in existing secret to use for PostgreSQL credentials. Only used when `auth.existingSecret` is set.
  ##
  secretKeys:
    adminPasswordKey: postgres-password
    userPasswordKey: password
    replicationPasswordKey: replication-password
  ## @param auth.usePasswordFiles Mount credentials as a files instead of using an environment variable
  ##
  usePasswordFiles: false
## @param architecture PostgreSQL architecture (`standalone` or `replication`)
##
architecture: ${resource.local_helm_config.pgsql_data.architecture}
## Replication configuration
## Ignored if `architecture` is `standalone`
##
replication:
  ## @param replication.synchronousCommit Set synchronous commit mode. Allowed values: `on`, `remote_apply`, `remote_write`, `local` and `off`
  ## @param replication.numSynchronousReplicas Number of replicas that will have synchronous replication. Note: Cannot be greater than `readReplicas.replicaCount`.
  ## ref: https://www.postgresql.org/docs/current/runtime-config-wal.html#GUC-SYNCHRONOUS-COMMIT
  ##
  synchronousCommit: "off"
  numSynchronousReplicas: ${resource.local_helm_config.pgsql_data.replica_count}
  ## @param replication.applicationName Cluster application name. Useful for advanced replication settings
  ##
  applicationName: my_application
## @param containerPorts.postgresql PostgreSQL container port
##
containerPorts:
  postgresql: 5432
## Audit settings
## https://github.com/bitnami/containers/tree/main/bitnami/postgresql#auditing
## @param audit.logHostname Log client hostnames
## @param audit.logConnections Add client log-in operations to the log file
## @param audit.logDisconnections Add client log-outs operations to the log file
## @param audit.pgAuditLog Add operations to log using the pgAudit extension
## @param audit.pgAuditLogCatalog Log catalog using pgAudit
## @param audit.clientMinMessages Message log level to share with the user
## @param audit.logLinePrefix Template for log line prefix (default if not set)
## @param audit.logTimezone Timezone for the log timestamps
##
audit:
  logHostname: false
  logConnections: false
  logDisconnections: false
  pgAuditLog: ""
  pgAuditLogCatalog: "off"
  clientMinMessages: error
  logLinePrefix: ""
  logTimezone: ""
## LDAP configuration
## @param ldap.enabled Enable LDAP support
## DEPRECATED ldap.url It will removed in a future, please use 'ldap.uri' instead
## @param ldap.server IP address or name of the LDAP server.
## @param ldap.port Port number on the LDAP server to connect to
## @param ldap.prefix String to prepend to the user name when forming the DN to bind
## @param ldap.suffix String to append to the user name when forming the DN to bind
## DEPRECATED ldap.baseDN It will removed in a future, please use 'ldap.basedn' instead
## DEPRECATED ldap.bindDN It will removed in a future, please use 'ldap.binddn' instead
## DEPRECATED ldap.bind_password It will removed in a future, please use 'ldap.bindpw' instead
## @param ldap.basedn Root DN to begin the search for the user in
## @param ldap.binddn DN of user to bind to LDAP
## @param ldap.bindpw Password for the user to bind to LDAP
## DEPRECATED ldap.search_attr It will removed in a future, please use 'ldap.searchAttribute' instead
## DEPRECATED ldap.search_filter It will removed in a future, please use 'ldap.searchFilter' instead
## @param ldap.searchAttribute Attribute to match against the user name in the search
## @param ldap.searchFilter The search filter to use when doing search+bind authentication
## @param ldap.scheme Set to `ldaps` to use LDAPS
## DEPRECATED ldap.tls as string is deprecated，please use 'ldap.tls.enabled' instead
## @param ldap.tls.enabled Se to true to enable TLS encryption
##
ldap:
  enabled: false
  server: ""
  port: ""
  prefix: ""
  suffix: ""
  basedn: ""
  binddn: ""
  bindpw: ""
  searchAttribute: ""
  searchFilter: ""
  scheme: ""
  tls:
    enabled: false
  ## @param ldap.uri LDAP URL beginning in the form `ldap[s]://host[:port]/basedn`. If provided, all the other LDAP parameters will be ignored.
  ## Ref: https://www.postgresql.org/docs/current/auth-ldap.html
  ##
  uri: ""
## @param postgresqlDataDir PostgreSQL data dir folder
##
postgresqlDataDir: /bitnami/postgresql/data
## @param postgresqlSharedPreloadLibraries Shared preload libraries (comma-separated list)
##
postgresqlSharedPreloadLibraries: "pgaudit"
## Start PostgreSQL pod(s) without limitations on shm memory.
## By default docker and containerd (and possibly other container runtimes) limit `/dev/shm` to `64M`
## ref: https://github.com/docker-library/postgres/issues/416
## ref: https://github.com/containerd/containerd/issues/3654
##
shmVolume:
  ## @param shmVolume.enabled Enable emptyDir volume for /dev/shm for PostgreSQL pod(s)
  ##
  enabled: true
  ## @param shmVolume.sizeLimit Set this to enable a size limit on the shm tmpfs
  ## Note: the size of the tmpfs counts against container's memory limit
  ## e.g:
  ## sizeLimit: 1Gi
  ##
  sizeLimit: ""
## TLS configuration
##
tls:
  ## @param tls.enabled Enable TLS traffic support
  ##
  enabled: false
  ## @param tls.autoGenerated Generate automatically self-signed TLS certificates
  ##
  autoGenerated: false
  ## @param tls.preferServerCiphers Whether to use the server's TLS cipher preferences rather than the client's
  ##
  preferServerCiphers: true
  ## @param tls.certificatesSecret Name of an existing secret that contains the certificates
  ##
  certificatesSecret: ""
  ## @param tls.certFilename Certificate filename
  ##
  certFilename: ""
  ## @param tls.certKeyFilename Certificate key filename
  ##
  certKeyFilename: ""
  ## @param tls.certCAFilename CA Certificate filename
  ## If provided, PostgreSQL will authenticate TLS/SSL clients by requesting them a certificate
  ## ref: https://www.postgresql.org/docs/9.6/auth-methods.html
  ##
  certCAFilename: ""
  ## @param tls.crlFilename File containing a Certificate Revocation List
  ##
  crlFilename: ""

## @section PostgreSQL Primary parameters
##
primary:
  ## @param primary.name Name of the primary database (eg primary, master, leader, ...)
  ##
  name: primary
  ## @param primary.configuration PostgreSQL Primary main configuration to be injected as ConfigMap
  ## ref: https://www.postgresql.org/docs/current/static/runtime-config.html
  ##
  configuration: ""
  ## @param primary.pgHbaConfiguration PostgreSQL Primary client authentication configuration
  ## ref: https://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html
  ## e.g:#
  ## pgHbaConfiguration: |-
  ##   local all all trust
  ##   host all all localhost trust
  ##   host mydatabase mysuser 192.168.0.0/24 md5
  ##
  pgHbaConfiguration: ""
  ## @param primary.existingConfigmap Name of an existing ConfigMap with PostgreSQL Primary configuration
  ## NOTE: `primary.configuration` and `primary.pgHbaConfiguration` will be ignored
  ##
  existingConfigmap: ""
  ## @param primary.extendedConfiguration Extended PostgreSQL Primary configuration (appended to main or default configuration)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql#allow-settings-to-be-loaded-from-files-other-than-the-default-postgresqlconf
  ##
  extendedConfiguration: ""
  ## @param primary.existingExtendedConfigmap Name of an existing ConfigMap with PostgreSQL Primary extended configuration
  ## NOTE: `primary.extendedConfiguration` will be ignored
  ##
  existingExtendedConfigmap: ""
  ## Initdb configuration
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql#specifying-initdb-arguments
  ##
  initdb:
    ## @param primary.initdb.args PostgreSQL initdb extra arguments
    ##
    args: ""
    ## @param primary.initdb.postgresqlWalDir Specify a custom location for the PostgreSQL transaction log
    ##
    postgresqlWalDir: ""
    ## @param primary.initdb.scripts Dictionary of initdb scripts
    ## Specify dictionary of scripts to be run at first boot
    ## e.g:
    ## scripts:
    ##   my_init_script.sh: |
    ##      #!/bin/sh
    ##      echo "Do something."
    ##
    scripts: {}
    ## @param primary.initdb.scriptsConfigMap ConfigMap with scripts to be run at first boot
    ## NOTE: This will override `primary.initdb.scripts`
    ##
    scriptsConfigMap: ""
    ## @param primary.initdb.scriptsSecret Secret with scripts to be run at first boot (in case it contains sensitive information)
    ## NOTE: This can work along `primary.initdb.scripts` or `primary.initdb.scriptsConfigMap`
    ##
    scriptsSecret: ""
    ## @param primary.initdb.user Specify the PostgreSQL username to execute the initdb scripts
    ##
    user: ""
    ## @param primary.initdb.password Specify the PostgreSQL password to execute the initdb scripts
    ##
    password: ""
  ## Configure current cluster's primary server to be the standby server in other cluster.
  ## This will allow cross cluster replication and provide cross cluster high availability.
  ## You will need to configure pgHbaConfiguration if you want to enable this feature with local cluster replication enabled.
  ## @param primary.standby.enabled Whether to enable current cluster's primary as standby server of another cluster or not
  ## @param primary.standby.primaryHost The Host of replication primary in the other cluster
  ## @param primary.standby.primaryPort The Port of replication primary in the other cluster
  ##
  standby:
    enabled: false
    primaryHost: ""
    primaryPort: ""
  ## @param primary.extraEnvVars Array with extra environment variables to add to PostgreSQL Primary nodes
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## @param primary.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for PostgreSQL Primary nodes
  ##
  extraEnvVarsCM: ""
  ## @param primary.extraEnvVarsSecret Name of existing Secret containing extra env vars for PostgreSQL Primary nodes
  ##
  extraEnvVarsSecret: ""
  ## @param primary.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param primary.args Override default container args (useful when using custom images)
  ##
  args: []
  ## Configure extra options for PostgreSQL Primary containers' liveness, readiness and startup probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes
  ## @param primary.livenessProbe.enabled Enable livenessProbe on PostgreSQL Primary containers
  ## @param primary.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param primary.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param primary.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param primary.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param primary.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 6
    successThreshold: 1
  ## @param primary.readinessProbe.enabled Enable readinessProbe on PostgreSQL Primary containers
  ## @param primary.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param primary.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param primary.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param primary.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param primary.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 6
    successThreshold: 1
  ## @param primary.startupProbe.enabled Enable startupProbe on PostgreSQL Primary containers
  ## @param primary.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param primary.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param primary.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param primary.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param primary.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 15
    successThreshold: 1
  ## @param primary.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param primary.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## @param primary.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param primary.lifecycleHooks for the PostgreSQL Primary container to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## PostgreSQL Primary resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param primary.resources.limits The resources limits for the PostgreSQL Primary containers
  ## @param primary.resources.requests.memory The requested memory for the PostgreSQL Primary containers
  ## @param primary.resources.requests.cpu The requested cpu for the PostgreSQL Primary containers
  ##
  resources:
    limits: {}
    requests:
      memory: 256Mi
      cpu: 250m
  ## Pod Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param primary.podSecurityContext.enabled Enable security context
  ## @param primary.podSecurityContext.fsGroup Group ID for the pod
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param primary.containerSecurityContext.enabled Enable container security context
  ## @param primary.containerSecurityContext.runAsUser User ID for the container
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  ## @param primary.hostAliases PostgreSQL primary pods host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param primary.hostNetwork Specify if host network should be enabled for PostgreSQL pod (postgresql primary)
  ##
  hostNetwork: false
  ## @param primary.hostIPC Specify if host IPC should be enabled for PostgreSQL pod (postgresql primary)
  ##
  hostIPC: false
  ## @param primary.labels Map of labels to add to the statefulset (postgresql primary)
  ##
  labels: {}
  ## @param primary.annotations Annotations for PostgreSQL primary pods
  ##
  annotations: {}
  ## @param primary.podLabels Map of labels to add to the pods (postgresql primary)
  ##
  podLabels: {}
  ## @param primary.podAnnotations Map of annotations to add to the pods (postgresql primary)
  ##
  podAnnotations: {}
  ## @param primary.podAffinityPreset PostgreSQL primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param primary.podAntiAffinityPreset PostgreSQL primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## PostgreSQL Primary node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param primary.nodeAffinityPreset.type PostgreSQL primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param primary.nodeAffinityPreset.key PostgreSQL primary node label key to match Ignored if `primary.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param primary.nodeAffinityPreset.values PostgreSQL primary node label values to match. Ignored if `primary.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param primary.affinity Affinity for PostgreSQL primary pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: primary.podAffinityPreset, primary.podAntiAffinityPreset, and primary.nodeAffinityPreset will be ignored when it's set
  ##
  affinity: {}
  ## @param primary.nodeSelector Node labels for PostgreSQL primary pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param primary.tolerations Tolerations for PostgreSQL primary pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param primary.topologySpreadConstraints Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template
  ## Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/#spread-constraints-for-pods
  ##
  topologySpreadConstraints: []
  ## @param primary.priorityClassName Priority Class to use for each pod (postgresql primary)
  ##
  priorityClassName: ""
  ## @param primary.schedulerName Use an alternate scheduler, e.g. "stork".
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param primary.terminationGracePeriodSeconds Seconds PostgreSQL primary pod needs to terminate gracefully
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
  ##
  terminationGracePeriodSeconds: ""
  ## @param primary.updateStrategy.type PostgreSQL Primary statefulset strategy type
  ## @param primary.updateStrategy.rollingUpdate PostgreSQL Primary statefulset rolling update configuration parameters
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy:
    type: RollingUpdate
    rollingUpdate: {}
  ## @param primary.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the PostgreSQL Primary container(s)
  ##
  extraVolumeMounts: []
  ## @param primary.extraVolumes Optionally specify extra list of additional volumes for the PostgreSQL Primary pod(s)
  ##
  extraVolumes: []
  ## @param primary.sidecars Add additional sidecar containers to the PostgreSQL Primary pod(s)
  ## For example:
  ## sidecars:
  ##   - name: your-image-name
  ##     image: your-image
  ##     imagePullPolicy: Always
  ##     ports:
  ##       - name: portname
  ##         containerPort: 1234
  ##
  sidecars: []
  ## @param primary.initContainers Add additional init containers to the PostgreSQL Primary pod(s)
  ## Example
  ##
  ## initContainers:
  ##   - name: do-something
  ##     image: busybox
  ##     command: ['do', 'something']
  ##
  initContainers: []
  ## @param primary.extraPodSpec Optionally specify extra PodSpec for the PostgreSQL Primary pod(s)
  ##
  extraPodSpec: {}
  ## PostgreSQL Primary service configuration
  ##
  service:
    ## @param primary.service.type Kubernetes Service type
    ##
    type: ClusterIP
    ## @param primary.service.ports.postgresql PostgreSQL service port
    ##
    ports:
      postgresql: 5432
    ## Node ports to expose
    ## NOTE: choose port between <30000-32767>
    ## @param primary.service.nodePorts.postgresql Node port for PostgreSQL
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ##
    nodePorts:
      postgresql: ""
    ## @param primary.service.clusterIP Static clusterIP or None for headless services
    ## e.g:
    ## clusterIP: None
    ##
    clusterIP: ""
    ## @param primary.service.annotations Annotations for PostgreSQL primary service
    ##
    annotations: {}
    ## @param primary.service.loadBalancerIP Load balancer IP if service type is `LoadBalancer`
    ## Set the LoadBalancer service type to internal only
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param primary.service.externalTrafficPolicy Enable client source IP preservation
    ## ref https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param primary.service.loadBalancerSourceRanges Addresses that are allowed when service is LoadBalancer
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ##
    ## loadBalancerSourceRanges:
    ## - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param primary.service.extraPorts Extra ports to expose in the PostgreSQL primary service
    ##
    extraPorts: []
    ## @param primary.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param primary.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
    ## Headless service properties
    ##
    headless:
      ## @param primary.service.headless.annotations Additional custom annotations for headless PostgreSQL primary service
      ##
      annotations: {}
  ## PostgreSQL Primary persistence configuration
  ##
  persistence:
    ## @param primary.persistence.enabled Enable PostgreSQL Primary data persistence using PVC
    ##
    enabled: true
    ## @param primary.persistence.existingClaim Name of an existing PVC to use
    ##
    existingClaim: ""
    ## @param primary.persistence.mountPath The path the volume will be mounted at
    ## Note: useful when using custom PostgreSQL images
    ##
    mountPath: /bitnami/postgresql
    ## @param primary.persistence.subPath The subdirectory of the volume to mount to
    ## Useful in dev environments and one PV for multiple services
    ##
    subPath: ""
    ## @param primary.persistence.storageClass PVC Storage Class for PostgreSQL Primary data volume
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is
    ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
    ##   GKE, AWS & OpenStack)
    ##
    storageClass: ""
    ## @param primary.persistence.accessModes PVC Access Mode for PostgreSQL volume
    ##
    accessModes:
      - ReadWriteOnce
    ## @param primary.persistence.size PVC Storage Request for PostgreSQL volume
    ##
    size: ${resource.local_helm_config.pgsql_data.storage_size}
    ## @param primary.persistence.annotations Annotations for the PVC
    ##
    annotations: {}
    ## @param primary.persistence.labels Labels for the PVC
    ##
    labels: {}
    ## @param primary.persistence.selector Selector to match an existing Persistent Volume (this value is evaluated as a template)
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
    ## @param primary.persistence.dataSource Custom PVC data source
    ##
    dataSource: {}

## @section PostgreSQL read only replica parameters (only used when `architecture` is set to `replication`)
##
readReplicas:
  ## @param readReplicas.name Name of the read replicas database (eg secondary, slave, ...)
  ##
  name: read
  ## @param readReplicas.replicaCount Number of PostgreSQL read only replicas
  ##
  replicaCount: ${resource.local_helm_config.pgsql_data.replica_count}
  ## @param readReplicas.extendedConfiguration Extended PostgreSQL read only replicas configuration (appended to main or default configuration)
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/postgresql#allow-settings-to-be-loaded-from-files-other-than-the-default-postgresqlconf
  ##
  extendedConfiguration: ""
  ## @param readReplicas.extraEnvVars Array with extra environment variables to add to PostgreSQL read only nodes
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## @param readReplicas.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for PostgreSQL read only nodes
  ##
  extraEnvVarsCM: ""
  ## @param readReplicas.extraEnvVarsSecret Name of existing Secret containing extra env vars for PostgreSQL read only nodes
  ##
  extraEnvVarsSecret: ""
  ## @param readReplicas.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param readReplicas.args Override default container args (useful when using custom images)
  ##
  args: []
  ## Configure extra options for PostgreSQL read only containers' liveness, readiness and startup probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes
  ## @param readReplicas.livenessProbe.enabled Enable livenessProbe on PostgreSQL read only containers
  ## @param readReplicas.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param readReplicas.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param readReplicas.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param readReplicas.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param readReplicas.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 6
    successThreshold: 1
  ## @param readReplicas.readinessProbe.enabled Enable readinessProbe on PostgreSQL read only containers
  ## @param readReplicas.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param readReplicas.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param readReplicas.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param readReplicas.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param readReplicas.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 6
    successThreshold: 1
  ## @param readReplicas.startupProbe.enabled Enable startupProbe on PostgreSQL read only containers
  ## @param readReplicas.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param readReplicas.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param readReplicas.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param readReplicas.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param readReplicas.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 15
    successThreshold: 1
  ## @param readReplicas.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param readReplicas.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## @param readReplicas.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param readReplicas.lifecycleHooks for the PostgreSQL read only container to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## PostgreSQL read only resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param readReplicas.resources.limits The resources limits for the PostgreSQL read only containers
  ## @param readReplicas.resources.requests.memory The requested memory for the PostgreSQL read only containers
  ## @param readReplicas.resources.requests.cpu The requested cpu for the PostgreSQL read only containers
  ##
  resources:
    limits: {}
    requests:
      memory: 256Mi
      cpu: 250m
  ## Pod Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param readReplicas.podSecurityContext.enabled Enable security context
  ## @param readReplicas.podSecurityContext.fsGroup Group ID for the pod
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
  ## @param readReplicas.containerSecurityContext.enabled Enable container security context
  ## @param readReplicas.containerSecurityContext.runAsUser User ID for the container
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  ## @param readReplicas.hostAliases PostgreSQL read only pods host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param readReplicas.hostNetwork Specify if host network should be enabled for PostgreSQL pod (PostgreSQL read only)
  ##
  hostNetwork: false
  ## @param readReplicas.hostIPC Specify if host IPC should be enabled for PostgreSQL pod (postgresql primary)
  ##
  hostIPC: false
  ## @param readReplicas.labels Map of labels to add to the statefulset (PostgreSQL read only)
  ##
  labels: {}
  ## @param readReplicas.annotations Annotations for PostgreSQL read only pods
  ##
  annotations: {}
  ## @param readReplicas.podLabels Map of labels to add to the pods (PostgreSQL read only)
  ##
  podLabels: {}
  ## @param readReplicas.podAnnotations Map of annotations to add to the pods (PostgreSQL read only)
  ##
  podAnnotations: {}
  ## @param readReplicas.podAffinityPreset PostgreSQL read only pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param readReplicas.podAntiAffinityPreset PostgreSQL read only pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## PostgreSQL read only node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param readReplicas.nodeAffinityPreset.type PostgreSQL read only node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param readReplicas.nodeAffinityPreset.key PostgreSQL read only node label key to match Ignored if `primary.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param readReplicas.nodeAffinityPreset.values PostgreSQL read only node label values to match. Ignored if `primary.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param readReplicas.affinity Affinity for PostgreSQL read only pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: primary.podAffinityPreset, primary.podAntiAffinityPreset, and primary.nodeAffinityPreset will be ignored when it's set
  ##
  affinity: {}
  ## @param readReplicas.nodeSelector Node labels for PostgreSQL read only pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param readReplicas.tolerations Tolerations for PostgreSQL read only pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param readReplicas.topologySpreadConstraints Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template
  ## Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/#spread-constraints-for-pods
  ##
  topologySpreadConstraints: []
  ## @param readReplicas.priorityClassName Priority Class to use for each pod (PostgreSQL read only)
  ##
  priorityClassName: ""
  ## @param readReplicas.schedulerName Use an alternate scheduler, e.g. "stork".
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param readReplicas.terminationGracePeriodSeconds Seconds PostgreSQL read only pod needs to terminate gracefully
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
  ##
  terminationGracePeriodSeconds: ""
  ## @param readReplicas.updateStrategy.type PostgreSQL read only statefulset strategy type
  ## @param readReplicas.updateStrategy.rollingUpdate PostgreSQL read only statefulset rolling update configuration parameters
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy:
    type: RollingUpdate
    rollingUpdate: {}
  ## @param readReplicas.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the PostgreSQL read only container(s)
  ##
  extraVolumeMounts: []
  ## @param readReplicas.extraVolumes Optionally specify extra list of additional volumes for the PostgreSQL read only pod(s)
  ##
  extraVolumes: []
  ## @param readReplicas.sidecars Add additional sidecar containers to the PostgreSQL read only pod(s)
  ## For example:
  ## sidecars:
  ##   - name: your-image-name
  ##     image: your-image
  ##     imagePullPolicy: Always
  ##     ports:
  ##       - name: portname
  ##         containerPort: 1234
  ##
  sidecars: []
  ## @param readReplicas.initContainers Add additional init containers to the PostgreSQL read only pod(s)
  ## Example
  ##
  ## initContainers:
  ##   - name: do-something
  ##     image: busybox
  ##     command: ['do', 'something']
  ##
  initContainers: []
  ## @param readReplicas.extraPodSpec Optionally specify extra PodSpec for the PostgreSQL read only pod(s)
  ##
  extraPodSpec: {}
  ## PostgreSQL read only service configuration
  ##
  service:
    ## @param readReplicas.service.type Kubernetes Service type
    ##
    type: ClusterIP
    ## @param readReplicas.service.ports.postgresql PostgreSQL service port
    ##
    ports:
      postgresql: 5432
    ## Node ports to expose
    ## NOTE: choose port between <30000-32767>
    ## @param readReplicas.service.nodePorts.postgresql Node port for PostgreSQL
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ##
    nodePorts:
      postgresql: ""
    ## @param readReplicas.service.clusterIP Static clusterIP or None for headless services
    ## e.g:
    ## clusterIP: None
    ##
    clusterIP: ""
    ## @param readReplicas.service.annotations Annotations for PostgreSQL read only service
    ##
    annotations: {}
    ## @param readReplicas.service.loadBalancerIP Load balancer IP if service type is `LoadBalancer`
    ## Set the LoadBalancer service type to internal only
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param readReplicas.service.externalTrafficPolicy Enable client source IP preservation
    ## ref https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param readReplicas.service.loadBalancerSourceRanges Addresses that are allowed when service is LoadBalancer
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ##
    ## loadBalancerSourceRanges:
    ## - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param readReplicas.service.extraPorts Extra ports to expose in the PostgreSQL read only service
    ##
    extraPorts: []
    ## @param readReplicas.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param readReplicas.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
    ## Headless service properties
    ##
    headless:
      ## @param readReplicas.service.headless.annotations Additional custom annotations for headless PostgreSQL read only service
      ##
      annotations: {}
  ## PostgreSQL read only persistence configuration
  ##
  persistence:
    ## @param readReplicas.persistence.enabled Enable PostgreSQL read only data persistence using PVC
    ##
    enabled: true
    ## @param readReplicas.persistence.existingClaim Name of an existing PVC to use
    ##
    existingClaim: ""
    ## @param readReplicas.persistence.mountPath The path the volume will be mounted at
    ## Note: useful when using custom PostgreSQL images
    ##
    mountPath: /bitnami/postgresql
    ## @param readReplicas.persistence.subPath The subdirectory of the volume to mount to
    ## Useful in dev environments and one PV for multiple services
    ##
    subPath: ""
    ## @param readReplicas.persistence.storageClass PVC Storage Class for PostgreSQL read only data volume
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is
    ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
    ##   GKE, AWS & OpenStack)
    ##
    storageClass: ""
    ## @param readReplicas.persistence.accessModes PVC Access Mode for PostgreSQL volume
    ##
    accessModes:
      - ReadWriteOnce
    ## @param readReplicas.persistence.size PVC Storage Request for PostgreSQL volume
    ##
    size: ${resource.local_helm_config.pgsql_data.storage_size}
    ## @param readReplicas.persistence.annotations Annotations for the PVC
    ##
    annotations: {}
    ## @param readReplicas.persistence.labels Labels for the PVC
    ##
    labels: {}
    ## @param readReplicas.persistence.selector Selector to match an existing Persistent Volume (this value is evaluated as a template)
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
    ## @param readReplicas.persistence.dataSource Custom PVC data source
    ##
    dataSource: {}

## @section NetworkPolicy parameters
##

## Add networkpolicies
##
networkPolicy:
  ## @param networkPolicy.enabled Enable network policies
  ##
  enabled: false
  ## @param networkPolicy.metrics.enabled Enable network policies for metrics (prometheus)
  ## @param networkPolicy.metrics.namespaceSelector [object] Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.
  ## @param networkPolicy.metrics.podSelector [object] Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.
  ##
  metrics:
    enabled: false
    ## e.g:
    ## namespaceSelector:
    ##   label: monitoring
    ##
    namespaceSelector: {}
    ## e.g:
    ## podSelector:
    ##   label: monitoring
    ##
    podSelector: {}
  ## Ingress Rules
  ##
  ingressRules:
    ## @param networkPolicy.ingressRules.primaryAccessOnlyFrom.enabled Enable ingress rule that makes PostgreSQL primary node only accessible from a particular origin.
    ## @param networkPolicy.ingressRules.primaryAccessOnlyFrom.namespaceSelector [object] Namespace selector label that is allowed to access the PostgreSQL primary node. This label will be used to identified the allowed namespace(s).
    ## @param networkPolicy.ingressRules.primaryAccessOnlyFrom.podSelector [object] Pods selector label that is allowed to access the PostgreSQL primary node. This label will be used to identified the allowed pod(s).
    ## @param networkPolicy.ingressRules.primaryAccessOnlyFrom.customRules Custom network policy for the PostgreSQL primary node.
    ##
    primaryAccessOnlyFrom:
      enabled: false
      ## e.g:
      ## namespaceSelector:
      ##   label: ingress
      ##
      namespaceSelector: {}
      ## e.g:
      ## podSelector:
      ##   label: access
      ##
      podSelector: {}
      ## custom ingress rules
      ## e.g:
      ## customRules:
      ##   - from:
      ##       - namespaceSelector:
      ##           matchLabels:
      ##             label: example
      ##
      customRules: []
    ## @param networkPolicy.ingressRules.readReplicasAccessOnlyFrom.enabled Enable ingress rule that makes PostgreSQL read-only nodes only accessible from a particular origin.
    ## @param networkPolicy.ingressRules.readReplicasAccessOnlyFrom.namespaceSelector [object] Namespace selector label that is allowed to access the PostgreSQL read-only nodes. This label will be used to identified the allowed namespace(s).
    ## @param networkPolicy.ingressRules.readReplicasAccessOnlyFrom.podSelector [object] Pods selector label that is allowed to access the PostgreSQL read-only nodes. This label will be used to identified the allowed pod(s).
    ## @param networkPolicy.ingressRules.readReplicasAccessOnlyFrom.customRules Custom network policy for the PostgreSQL read-only nodes.
    ##
    readReplicasAccessOnlyFrom:
      enabled: false
      ## e.g:
      ## namespaceSelector:
      ##   label: ingress
      ##
      namespaceSelector: {}
      ## e.g:
      ## podSelector:
      ##   label: access
      ##
      podSelector: {}
      ## custom ingress rules
      ## e.g:
      ## CustomRules:
      ##   - from:
      ##       - namespaceSelector:
      ##           matchLabels:
      ##             label: example
      ##
      customRules: []
  ## @param networkPolicy.egressRules.denyConnectionsToExternal Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).
  ## @param networkPolicy.egressRules.customRules Custom network policy rule
  ##
  egressRules:
    # Deny connections to external. This is not compatible with an external database.
    denyConnectionsToExternal: false
    ## Additional custom egress rules
    ## e.g:
    ## customRules:
    ##   - to:
    ##       - namespaceSelector:
    ##           matchLabels:
    ##             label: example
    ##
    customRules: []

## @section Volume Permissions parameters
##

## Init containers parameters:
## volumePermissions: Change the owner and group of the persistent volume(s) mountpoint(s) to 'runAsUser:fsGroup' on each node
##
volumePermissions:
  ## @param volumePermissions.enabled Enable init container that changes the owner and group of the persistent volume
  ##
  enabled: false
  ## @param volumePermissions.image.registry Init container volume-permissions image registry
  ## @param volumePermissions.image.repository Init container volume-permissions image repository
  ## @param volumePermissions.image.tag Init container volume-permissions image tag (immutable tags are recommended)
  ## @param volumePermissions.image.digest Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param volumePermissions.image.pullPolicy Init container volume-permissions image pull policy
  ## @param volumePermissions.image.pullSecrets Init container volume-permissions image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/os-shell
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## Example:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## Init container resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param volumePermissions.resources.limits Init container volume-permissions resource limits
  ## @param volumePermissions.resources.requests Init container volume-permissions resource requests
  ##
  resources:
    limits: {}
    requests: {}
  ## Init container' Security Context
  ## Note: the chown of the data folder is done to containerSecurityContext.runAsUser
  ## and not the below volumePermissions.containerSecurityContext.runAsUser
  ## @param volumePermissions.containerSecurityContext.runAsUser User ID for the init container
  ##
  containerSecurityContext:
    runAsUser: 0

## @section Other Parameters
##

## @param serviceBindings.enabled Create secret for service binding (Experimental)
## Ref: https://servicebinding.io/service-provider/
##
serviceBindings:
  enabled: false

## Service account for PostgreSQL to use.
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
##
serviceAccount:
  ## @param serviceAccount.create Enable creation of ServiceAccount for PostgreSQL pod
  ##
  create: false
  ## @param serviceAccount.name The name of the ServiceAccount to use.
  ## If not set and create is true, a name is generated using the common.names.fullname template
  ##
  name: ""
  ## @param serviceAccount.automountServiceAccountToken Allows auto mount of ServiceAccountToken on the serviceAccount created
  ## Can be set to false if pods using this serviceAccount do not need to use K8s API
  ##
  automountServiceAccountToken: true
  ## @param serviceAccount.annotations Additional custom annotations for the ServiceAccount
  ##
  annotations: {}
## Creates role for ServiceAccount
## @param rbac.create Create Role and RoleBinding (required for PSP to work)
##
rbac:
  create: false
  ## @param rbac.rules Custom RBAC rules to set
  ## e.g:
  ## rules:
  ##   - apiGroups:
  ##       - ""
  ##     resources:
  ##       - pods
  ##     verbs:
  ##       - get
  ##       - list
  ##
  rules: []
## Pod Security Policy
## ref: https://kubernetes.io/docs/concepts/policy/pod-security-policy/
## @param psp.create Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later
##
psp:
  create: false

## @section Metrics Parameters
##

metrics:
  ## @param metrics.enabled Start a prometheus exporter
  ##
  enabled: false
  ## @param metrics.image.registry PostgreSQL Prometheus Exporter image registry
  ## @param metrics.image.repository PostgreSQL Prometheus Exporter image repository
  ## @param metrics.image.tag PostgreSQL Prometheus Exporter image tag (immutable tags are recommended)
  ## @param metrics.image.digest PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param metrics.image.pullPolicy PostgreSQL Prometheus Exporter image pull policy
  ## @param metrics.image.pullSecrets Specify image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/postgres-exporter
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## Example:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param metrics.customMetrics Define additional custom metrics
  ## ref: https://github.com/wrouesnel/postgres_exporter#adding-new-metrics-via-a-config-file
  ## customMetrics:
  ##   pg_database:
  ##     query: "SELECT d.datname AS name, CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT') THEN pg_catalog.pg_database_size(d.datname) ELSE 0 END AS size_bytes FROM pg_catalog.pg_database d where datname not in ('template0', 'template1', 'postgres')"
  ##     metrics:
  ##       - name:
  ##           usage: "LABEL"
  ##           description: "Name of the database"
  ##       - size_bytes:
  ##           usage: "GAUGE"
  ##           description: "Size of the database in bytes"
  ##
  customMetrics: {}
  ## @param metrics.extraEnvVars Extra environment variables to add to PostgreSQL Prometheus exporter
  ## see: https://github.com/wrouesnel/postgres_exporter#environment-variables
  ## For example:
  ##  extraEnvVars:
  ##  - name: PG_EXPORTER_DISABLE_DEFAULT_METRICS
  ##    value: "true"
  ##
  extraEnvVars: []
  ## PostgreSQL Prometheus exporter containers' Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  ## @param metrics.containerSecurityContext.enabled Enable PostgreSQL Prometheus exporter containers' Security Context
  ## @param metrics.containerSecurityContext.runAsUser Set PostgreSQL Prometheus exporter containers' Security Context runAsUser
  ## @param metrics.containerSecurityContext.runAsNonRoot Set PostgreSQL Prometheus exporter containers' Security Context runAsNonRoot
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
    runAsNonRoot: true
  ## Configure extra options for PostgreSQL Prometheus exporter containers' liveness, readiness and startup probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes
  ## @param metrics.livenessProbe.enabled Enable livenessProbe on PostgreSQL Prometheus exporter containers
  ## @param metrics.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param metrics.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param metrics.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param metrics.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param metrics.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 6
    successThreshold: 1
  ## @param metrics.readinessProbe.enabled Enable readinessProbe on PostgreSQL Prometheus exporter containers
  ## @param metrics.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param metrics.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param metrics.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param metrics.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param metrics.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 6
    successThreshold: 1
  ## @param metrics.startupProbe.enabled Enable startupProbe on PostgreSQL Prometheus exporter containers
  ## @param metrics.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param metrics.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param metrics.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param metrics.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param metrics.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 15
    successThreshold: 1
  ## @param metrics.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param metrics.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## @param metrics.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param metrics.containerPorts.metrics PostgreSQL Prometheus exporter metrics container port
  ##
  containerPorts:
    metrics: 9187
  ## PostgreSQL Prometheus exporter resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param metrics.resources.limits The resources limits for the PostgreSQL Prometheus exporter container
  ## @param metrics.resources.requests The requested resources for the PostgreSQL Prometheus exporter container
  ##
  resources:
    limits: {}
    requests: {}
  ## Service configuration
  ##
  service:
    ## @param metrics.service.ports.metrics PostgreSQL Prometheus Exporter service port
    ##
    ports:
      metrics: 9187
    ## @param metrics.service.clusterIP Static clusterIP or None for headless services
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#choosing-your-own-ip-address
    ##
    clusterIP: ""
    ## @param metrics.service.sessionAffinity Control where client requests go, to the same pod or round-robin
    ## Values: ClientIP or None
    ## ref: https://kubernetes.io/docs/user-guide/services/
    ##
    sessionAffinity: None
    ## @param metrics.service.annotations [object] Annotations for Prometheus to auto-discover the metrics endpoint
    ##
    annotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "{{ .Values.metrics.service.ports.metrics }}"
  ## Prometheus Operator ServiceMonitor configuration
  ##
  serviceMonitor:
    ## @param metrics.serviceMonitor.enabled Create ServiceMonitor Resource for scraping metrics using Prometheus Operator
    ##
    enabled: false
    ## @param metrics.serviceMonitor.namespace Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)
    ##
    namespace: ""
    ## @param metrics.serviceMonitor.interval Interval at which metrics should be scraped.
    ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint
    ##
    interval: ""
    ## @param metrics.serviceMonitor.scrapeTimeout Timeout after which the scrape is ended
    ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint
    ##
    scrapeTimeout: ""
    ## @param metrics.serviceMonitor.labels Additional labels that can be used so ServiceMonitor will be discovered by Prometheus
    ##
    labels: {}
    ## @param metrics.serviceMonitor.selector Prometheus instance selector labels
    ## ref: https://github.com/bitnami/charts/tree/main/bitnami/prometheus-operator#prometheus-configuration
    ##
    selector: {}
    ## @param metrics.serviceMonitor.relabelings RelabelConfigs to apply to samples before scraping
    ##
    relabelings: []
    ## @param metrics.serviceMonitor.metricRelabelings MetricRelabelConfigs to apply to samples before ingestion
    ##
    metricRelabelings: []
    ## @param metrics.serviceMonitor.honorLabels Specify honorLabels parameter to add the scrape endpoint
    ##
    honorLabels: false
    ## @param metrics.serviceMonitor.jobLabel The name of the label on the target service to use as the job name in prometheus.
    ##
    jobLabel: ""
  ## Custom PrometheusRule to be defined
  ## The value is evaluated as a template, so, for example, the value can depend on .Release or .Chart
  ## ref: https://github.com/coreos/prometheus-operator#customresourcedefinitions
  ##
  prometheusRule:
    ## @param metrics.prometheusRule.enabled Create a PrometheusRule for Prometheus Operator
    ##
    enabled: false
    ## @param metrics.prometheusRule.namespace Namespace for the PrometheusRule Resource (defaults to the Release Namespace)
    ##
    namespace: ""
    ## @param metrics.prometheusRule.labels Additional labels that can be used so PrometheusRule will be discovered by Prometheus
    ##
    labels: {}
    ## @param metrics.prometheusRule.rules PrometheusRule definitions
    ## Make sure to constraint the rules to the current postgresql service.
    ## rules:
    ##   - alert: HugeReplicationLag
    ##     expr: pg_replication_lag{service="{{ printf "%s-metrics" (include "common.names.fullname" .) }}"} / 3600 > 1
    ##     for: 1m
    ##     labels:
    ##       severity: critical
    ##     annotations:
    ##       description: replication for {{ include "common.names.fullname" . }} PostgreSQL is lagging by {{ "{{ $value }}" }} hour(s).
    ##       summary: PostgreSQL replication is lagging by {{ "{{ $value }}" }} hour(s).
    ##
    rules: []
