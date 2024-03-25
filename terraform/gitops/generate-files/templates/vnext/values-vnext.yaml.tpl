# Custom YAML TEMPLATE Anchors
CONFIG:
  ## KAFKA BACKEND
  kafka_host: &KAFKA_HOST "${kafka_host}"
  kafka_port: &KAFKA_PORT ${kafka_port}
  kafka_url: &KAFKA_URL "${kafka_host}:${kafka_port}"
  redis_host: &REDIS_HOST "${redis_host}"
  redis_port: &REDIS_PORT ${redis_port}

  mongo_url_secret_name: "${mongodb_url_existing_secret}" &MONGO_URL_SECRET_NAME
  mongo_url_secret_key: "url" &MONGO_URL_SECRET_KEY


  ## Endpiont Security
  endpointSecurity: &ENDPOINT_SECURITY
    jwsSigningKeySecret: &JWS_SIGNING_KEY_SECRET
      name: ${jws_key_secret}
      key: ${jws_key_secret_private_key_key}
%{ if mojaloop_tolerations != null ~}
  tolerations: &MOJALOOP_TOLERATIONS
    ${indent(4, mojaloop_tolerations)}
%{ else ~}
    tolerations: &MOJALOOP_TOLERATIONS []
%{ endif ~}


account-lookup-http-oracle-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
account-lookup-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

accounts-and-balances-builtin-ledger-grpc-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
    redis_host: *REDIS_HOST
    redis_port: *REDIS_PORT
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

accounts-and-balances-coa-grpc-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
    redis_host: *REDIS_HOST
    redis_port: *REDIS_PORT
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

admin-ui:
  enabled: true

auditing-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL

authentication-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL

authorization-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL

fspiop-api-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

logging-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL

participants-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

platform-configuration-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL

quoting-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

settlements-api-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

settlements-command-handler-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

settlements-event-handler-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

transfers-api-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

transfers-command-handler-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY

transfers-event-handler-svc:
  enabled: true
  env:
    kafka_url: *KAFKA_URL
  extraEnvs:
    - name: MONGO_URL
      valueFrom:
        secretKeyRef:
          name: *MONGO_URL_SECRET_NAME
          key: *MONGO_URL_SECRET_KEY