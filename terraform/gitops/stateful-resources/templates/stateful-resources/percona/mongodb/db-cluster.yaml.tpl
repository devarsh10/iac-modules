apiVersion: psmdb.percona.com/v1
kind: PerconaServerMongoDB
metadata:
  name: my-cluster-name
  finalizers:
    - delete-psmdb-pods-in-order
#    - delete-psmdb-pvc
spec:
#  platform: openshift
#  clusterServiceDNSSuffix: svc.cluster.local
#  clusterServiceDNSMode: "Internal"
#  pause: true
#  unmanaged: false
  crVersion: ${cr_version}
#  tls:
#    mode: preferTLS
#    # 90 days in hours
#    certValidityDuration: 2160h    
#    allowInvalidCertificates: true
#    issuerConf:
#      name: special-selfsigned-issuer
#      kind: ClusterIssuer
#      group: cert-manager.io
#  imagePullSecrets:
#    - name: private-registry-credentials
#  initImage: perconalab/percona-server-mongodb-operator:main
#  initContainerSecurityContext: {}
#  unsafeFlags:
#    tls: false
#    replsetSize: false
#    mongosSize: false
#    terminationGracePeriod: false
#    backupIfUnhealthy: false
  updateStrategy: SmartUpdate
#  ignoreAnnotations:
#    - service.beta.kubernetes.io/aws-load-balancer-backend-protocol
#  ignoreLabels:
#    - rack
#  multiCluster:
#    enabled: true
#    DNSSuffix: svc.clusterset.local
  upgradeOptions:
    versionServiceEndpoint: https://check.percona.com
    apply: disabled
    schedule: "0 2 * * *"
    setFCV: false
  secrets:
    users: my-cluster-name-secrets
    encryptionKey: my-cluster-name-mongodb-encryption-key
#    vault: my-cluster-name-vault
#    ldapSecret: my-ldap-secret
#    sse: my-cluster-name-sse
  pmm:
    enabled: false
    image: perconalab/pmm-client:dev-latest
    serverHost: monitoring-service
#    mongodParams: --environment=ENVIRONMENT
#    mongosParams: --environment=ENVIRONMENT
  replsets:
  - name: rs0
    size: 3
#    terminationGracePeriodSeconds: 300
#    serviceAccountName: default
#    topologySpreadConstraints:
#      - labelSelector:
#          matchLabels:
#            app.kubernetes.io/name: percona-server-mongodb
#        maxSkew: 1
#        topologyKey: kubernetes.io/hostname
#        whenUnsatisfiable: DoNotSchedule
#    externalNodes:
#    - host: 34.124.76.90
#    - host: 34.124.76.91
#      port: 27017
#      votes: 0
#      priority: 0
#    - host: 34.124.76.92
#    # for more configuration fields refer to https://docs.mongodb.com/manual/reference/configuration-options/
#    configuration: |
#      operationProfiling:
#        mode: slowOp
#      systemLog:
#        verbosity: 1
#      storage:
#        engine: wiredTiger
#        wiredTiger:
#          engineConfig:
#            directoryForIndexes: false
#            journalCompressor: snappy
#          collectionConfig:
#            blockCompressor: snappy
#          indexConfig:
#            prefixCompression: true
    affinity:
      antiAffinityTopologyKey: "kubernetes.io/hostname"
#      advanced:
#        nodeAffinity:
#          requiredDuringSchedulingIgnoredDuringExecution:
#            nodeSelectorTerms:
#            - matchExpressions:
#              - key: kubernetes.io/e2e-az-name
#                operator: In
#                values:
#                - e2e-az1
#                - e2e-az2
#    tolerations:
#    - key: "node.alpha.kubernetes.io/unreachable"
#      operator: "Exists"
#      effect: "NoExecute"
#      tolerationSeconds: 6000
#    priorityClassName: high-priority
#    annotations:
#      iam.amazonaws.com/role: role-arn
#    labels:
#      rack: rack-22
#    nodeSelector:
#      disktype: ssd
#    storage:
#      engine: wiredTiger
#      wiredTiger:
#        engineConfig:
#          cacheSizeRatio: 0.5
#          directoryForIndexes: false
#          journalCompressor: snappy
#        collectionConfig:
#          blockCompressor: snappy
#        indexConfig:
#          prefixCompression: true
#      inMemory:
#        engineConfig:
#           inMemorySizeRatio: 0.5
#    livenessProbe:
#      failureThreshold: 4
#      initialDelaySeconds: 60
#      periodSeconds: 30
#      timeoutSeconds: 10
#      startupDelaySeconds: 7200
#    readinessProbe:
#      failureThreshold: 8
#      initialDelaySeconds: 10
#      periodSeconds: 3
#      successThreshold: 1
#      timeoutSeconds: 2
#    containerSecurityContext:
#      privileged: false
#    podSecurityContext:
#      runAsUser: 1001
#      runAsGroup: 1001
#      supplementalGroups: [1001]
#    runtimeClassName: image-rc
#    sidecars:
#    - image: busybox
#      command: ["/bin/sh"]
#      args: ["-c", "while true; do echo echo $(date -u) 'test' >> /dev/null; sleep 5;done"]
#      name: rs-sidecar-1
#      volumeMounts:
#        - mountPath: /volume1
#          name: sidecar-volume-claim
#        - mountPath: /secret
#          name: sidecar-secret
#        - mountPath: /configmap
#          name: sidecar-config
#    sidecarVolumes:
#    - name: sidecar-secret
#      secret:
#        secretName: mysecret
#    - name: sidecar-config
#      configMap:
#        name: myconfigmap
#    sidecarPVCs:
#    - apiVersion: v1
#      kind: PersistentVolumeClaim
#      metadata:
#        name: sidecar-volume-claim
#      spec:
#        resources:
#          requests:
#            storage: 1Gi
#        volumeMode: Filesystem
#        accessModes:
#          - ReadWriteOnce
    podDisruptionBudget:
      maxUnavailable: 1
#      minAvailable: 0
#    splitHorizons:
#      my-cluster-name-rs0-0:
#        external: rs0-0.mycluster.xyz
#        external-2: rs0-0.mycluster2.xyz
#      my-cluster-name-rs0-1:
#        external: rs0-1.mycluster.xyz
#        external-2: rs0-1.mycluster2.xyz
#      my-cluster-name-rs0-2:
#        external: rs0-2.mycluster.xyz
#        external-2: rs0-2.mycluster2.xyz
    expose:
      enabled: false
      exposeType: ClusterIP
#      loadBalancerSourceRanges:
#        - 10.0.0.0/8
#      serviceAnnotations:
#        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
#      serviceLabels:
#        rack: rack-22
    resources:
      limits:
        cpu: "300m"
        memory: "0.5G"
      requests:
        cpu: "300m"
        memory: "0.5G"
    volumeSpec:
#      emptyDir: {}
#      hostPath:
#        path: /data
#        type: Directory
      persistentVolumeClaim:
#        annotations:
#          volume.beta.kubernetes.io/storage-class: example-hostpath
#        labels:
#          rack: rack-22
#        storageClassName: standard
#        accessModes: [ "ReadWriteOnce" ]
        resources:
          requests:
            storage: 3Gi

    nonvoting:
      enabled: false
#      podSecurityContext: {}
#      containerSecurityContext: {}
      size: 3
#      # for more configuration fields refer to https://docs.mongodb.com/manual/reference/configuration-options/
#      configuration: |
#        operationProfiling:
#          mode: slowOp
#        systemLog:
#          verbosity: 1
      affinity:
        antiAffinityTopologyKey: "kubernetes.io/hostname"
#        advanced:
#          nodeAffinity:
#            requiredDuringSchedulingIgnoredDuringExecution:
#              nodeSelectorTerms:
#              - matchExpressions:
#                - key: kubernetes.io/e2e-az-name
#                  operator: In
#                  values:
#                  - e2e-az1
#                  - e2e-az2
#      tolerations:
#      - key: "node.alpha.kubernetes.io/unreachable"
#        operator: "Exists"
#        effect: "NoExecute"
#        tolerationSeconds: 6000
#      priorityClassName: high-priority
#      annotations:
#        iam.amazonaws.com/role: role-arn
#      labels:
#        rack: rack-22
#      nodeSelector:
#        disktype: ssd
      podDisruptionBudget:
        maxUnavailable: 1
#        minAvailable: 0
      resources:
        limits:
          cpu: "300m"
          memory: "0.5G"
        requests:
          cpu: "300m"
          memory: "0.5G"
      volumeSpec:
#        emptyDir: {}
#        hostPath:
#          path: /data
#          type: Directory
        persistentVolumeClaim:
#          annotations:
#            volume.beta.kubernetes.io/storage-class: example-hostpath
#          labels:
#            rack: rack-22
#          storageClassName: standard
#          accessModes: [ "ReadWriteOnce" ]
          resources:
            requests:
              storage: 3Gi
    arbiter:
      enabled: false
      size: 1
      affinity:
        antiAffinityTopologyKey: "kubernetes.io/hostname"
#        advanced:
#          nodeAffinity:
#            requiredDuringSchedulingIgnoredDuringExecution:
#              nodeSelectorTerms:
#              - matchExpressions:
#                - key: kubernetes.io/e2e-az-name
#                  operator: In
#                  values:
#                  - e2e-az1
#                  - e2e-az2
#      tolerations:
#      - key: "node.alpha.kubernetes.io/unreachable"
#        operator: "Exists"
#        effect: "NoExecute"
#        tolerationSeconds: 6000
#      priorityClassName: high-priority
#      annotations:
#        iam.amazonaws.com/role: role-arn
#      labels:
#        rack: rack-22
#      nodeSelector:
#        disktype: ssd
#    schedulerName: "default"
      resources:
        limits:
          cpu: "300m"
          memory: "0.5G"
        requests:
          cpu: "300m"
          memory: "0.5G"
#    hostAliases:
#    - ip: "10.10.0.2"
#      hostnames:
#      - "host1"
#      - "host2"

  sharding:
    enabled: true
#    balancer:
#      enabled: true
    configsvrReplSet:
      size: 3
#      terminationGracePeriodSeconds: 300
#      serviceAccountName: default
#      topologySpreadConstraints:
#        - labelSelector:
#            matchLabels:
#              app.kubernetes.io/name: percona-server-mongodb
#          maxSkew: 1
#          topologyKey: kubernetes.io/hostname
#          whenUnsatisfiable: DoNotSchedule
#      externalNodes:
#      - host: 34.124.76.93
#      - host: 34.124.76.94
#        port: 27017
#        votes: 0
#        priority: 0
#      - host: 34.124.76.95
#      # for more configuration fields refer to https://docs.mongodb.com/manual/reference/configuration-options/
#      configuration: |
#        operationProfiling:
#          mode: slowOp
#        systemLog:
#           verbosity: 1
      affinity:
        antiAffinityTopologyKey: "kubernetes.io/hostname"
#        advanced:
#          nodeAffinity:
#            requiredDuringSchedulingIgnoredDuringExecution:
#              nodeSelectorTerms:
#              - matchExpressions:
#                - key: kubernetes.io/e2e-az-name
#                  operator: In
#                  values:
#                  - e2e-az1
#                  - e2e-az2
#      tolerations:
#      - key: "node.alpha.kubernetes.io/unreachable"
#        operator: "Exists"
#        effect: "NoExecute"
#        tolerationSeconds: 6000
#      priorityClassName: high-priority
#      annotations:
#        iam.amazonaws.com/role: role-arn
#      labels:
#        rack: rack-22
#      nodeSelector:
#        disktype: ssd
#      livenessProbe:
#        failureThreshold: 4
#        initialDelaySeconds: 60
#        periodSeconds: 30
#        timeoutSeconds: 10
#        startupDelaySeconds: 7200
#      readinessProbe:
#        failureThreshold: 3
#        initialDelaySeconds: 10
#        periodSeconds: 3
#        successThreshold: 1
#        timeoutSeconds: 2
#      containerSecurityContext:
#        privileged: false
#      podSecurityContext:
#        runAsUser: 1001
#        runAsGroup: 1001
#        supplementalGroups: [1001]
#      runtimeClassName: image-rc
#      sidecars:
#      - image: busybox
#        command: ["/bin/sh"]
#        args: ["-c", "while true; do echo echo $(date -u) 'test' >> /dev/null; sleep 5;done"]
#        name: rs-sidecar-1
      podDisruptionBudget:
        maxUnavailable: 1
      expose:
        enabled: false
        exposeType: ClusterIP
#        loadBalancerSourceRanges:
#          - 10.0.0.0/8
#        serviceAnnotations:
#          service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
#        serviceLabels:
#          rack: rack-22
      resources:
        limits:
          cpu: "300m"
          memory: "0.5G"
        requests:
          cpu: "300m"
          memory: "0.5G"
      volumeSpec:
#       emptyDir: {}
#       hostPath:
#         path: /data
#         type: Directory
        persistentVolumeClaim:
#          annotations:
#            volume.beta.kubernetes.io/storage-class: example-hostpath
#          labels:
#            rack: rack-22
#          storageClassName: standard
#          accessModes: [ "ReadWriteOnce" ]
          resources:
            requests:
              storage: 3Gi
#      hostAliases:
#      - ip: "10.10.0.2"
#        hostnames:
#        - "host1"
#        - "host2"

    mongos:
      size: 3
#      terminationGracePeriodSeconds: 300
#      serviceAccountName: default
#      topologySpreadConstraints:
#        - labelSelector:
#            matchLabels:
#              app.kubernetes.io/name: percona-server-mongodb
#          maxSkew: 1
#          topologyKey: kubernetes.io/hostname
#          whenUnsatisfiable: DoNotSchedule
#      # for more configuration fields refer to https://docs.mongodb.com/manual/reference/configuration-options/
#      configuration: |
#        systemLog:
#           verbosity: 1
      affinity:
        antiAffinityTopologyKey: "kubernetes.io/hostname"
#        advanced:
#          nodeAffinity:
#            requiredDuringSchedulingIgnoredDuringExecution:
#              nodeSelectorTerms:
#              - matchExpressions:
#                - key: kubernetes.io/e2e-az-name
#                  operator: In
#                  values:
#                  - e2e-az1
#                  - e2e-az2
#      tolerations:
#      - key: "node.alpha.kubernetes.io/unreachable"
#        operator: "Exists"
#        effect: "NoExecute"
#        tolerationSeconds: 6000
#      priorityClassName: high-priority
#      annotations:
#        iam.amazonaws.com/role: role-arn
#      labels:
#        rack: rack-22
#      nodeSelector:
#        disktype: ssd
#      livenessProbe:
#        failureThreshold: 4
#        initialDelaySeconds: 60
#        periodSeconds: 30
#        timeoutSeconds: 10
#        startupDelaySeconds: 7200
#      readinessProbe:
#        failureThreshold: 3
#        initialDelaySeconds: 10
#        periodSeconds: 3
#        successThreshold: 1
#        timeoutSeconds: 2
#      containerSecurityContext:
#        privileged: false
#      podSecurityContext:
#        runAsUser: 1001
#        runAsGroup: 1001
#        supplementalGroups: [1001]
#      runtimeClassName: image-rc
#      sidecars:
#      - image: busybox
#        command: ["/bin/sh"]
#        args: ["-c", "while true; do echo echo $(date -u) 'test' >> /dev/null; sleep 5;done"]
#        name: rs-sidecar-1
      podDisruptionBudget:
        maxUnavailable: 1
      resources:
        limits:
          cpu: "300m"
          memory: "0.5G"
        requests:
          cpu: "300m"
          memory: "0.5G"
      expose:
        exposeType: ClusterIP
#        servicePerPod: true
#        loadBalancerSourceRanges:
#          - 10.0.0.0/8
#        serviceAnnotations:
#          service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
#        serviceLabels:
#          rack: rack-22
#        nodePort: 32017
#      hostAliases:
#      - ip: "10.10.0.2"
#        hostnames:
#        - "host1"
#        - "host2"

  backup:
    enabled: true
    image: perconalab/percona-server-mongodb-operator:main-backup
#    annotations:
#      iam.amazonaws.com/role: role-arn
#    resources:
#      limits:
#        cpu: "300m"
#        memory: "0.5G"
#      requests:
#        cpu: "300m"
#        memory: "0.5G"
#    containerSecurityContext:
#      privileged: false
#    storages:
#      s3-us-west:
#        type: s3
#        s3:
#          bucket: S3-BACKUP-BUCKET-NAME-HERE
#          credentialsSecret: my-cluster-name-backup-s3
#          serverSideEncryption:
#            kmsKeyID: 1234abcd-12ab-34cd-56ef-1234567890ab
#            sseAlgorithm: aws:kms
#            sseCustomerAlgorithm: AES256
#            sseCustomerKey: Y3VzdG9tZXIta2V5
#          retryer:
#            numMaxRetries: 3
#            minRetryDelay: 30ms
#            maxRetryDelay: 5m
#          region: us-west-2
#          prefix: ""
#          uploadPartSize: 10485760
#          maxUploadParts: 10000
#          storageClass: STANDARD
#          insecureSkipTLSVerify: false
#      minio:
#        type: s3
#        s3:
#          bucket: MINIO-BACKUP-BUCKET-NAME-HERE
#          region: us-east-1
#          credentialsSecret: my-cluster-name-backup-minio
#          endpointUrl: http://minio.psmdb.svc.cluster.local:9000/minio/
#          insecureSkipTLSVerify: false
#          prefix: ""
#      azure-blob:
#        type: azure
#        azure:
#          container: CONTAINER-NAME
#          prefix: PREFIX-NAME
#          endpointUrl: https://accountName.blob.core.windows.net
#          credentialsSecret: SECRET-NAME
    pitr:
      enabled: false
      oplogOnly: false
#      oplogSpanMin: 10
      compressionType: gzip
      compressionLevel: 6
#    configuration:
#      backupOptions:
#        priority:
#          "localhost:28019": 2.5
#          "localhost:27018": 2.5
#        timeouts:
#          startingStatus: 33
#        oplogSpanMin: 10
#      restoreOptions:
#        batchSize: 500
#        numInsertionWorkers: 10
#        numDownloadWorkers: 4
#        maxDownloadBufferMb: 0
#        downloadChunkMb: 32
#        mongodLocation: /usr/bin/mongo
#        mongodLocationMap:
#          "node01:2017": /usr/bin/mongo
#          "node03:27017": /usr/bin/mongo
#    tasks:
#      - name: daily-s3-us-west
#        enabled: true
#        schedule: "0 0 * * *"
#        keep: 3
#        storageName: s3-us-west
#        compressionType: gzip
#        compressionLevel: 6
#      - name: weekly-s3-us-west
#        enabled: false
#        schedule: "0 0 * * 0"
#        keep: 5
#        storageName: s3-us-west
#        compressionType: gzip
#        compressionLevel: 6
#      - name: weekly-s3-us-west-physical
#        enabled: false
#        schedule: "0 5 * * 0"
#        keep: 5
#        type: physical
#        storageName: s3-us-west
#        compressionType: gzip
#        compressionLevel: 6