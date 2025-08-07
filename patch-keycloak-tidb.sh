#!/bin/bash

# TODO also need to remove db-driver config
# Maybe easier to just create a new Keycloak CR?
kubectl -n runner-keycloak patch Keycloak keycloak \
  --type='merge' \
  --patch='{"spec":{"image":"quay.io/keycloak/keycloak:26.3","db":{"url":"jdbc:mysql://advanced-tidb-tidb.tidb-cluster.svc.cluster.local:4000/keycloak?user=root","vendor":"mysql"}}}'

