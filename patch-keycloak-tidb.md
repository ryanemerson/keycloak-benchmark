# TIDB

1. Install Operator `./install-tidb-operator.sh`
2. Create TiDB cluster `./create-tidb-cluster.sh`
3. Create keycloak DB via port-forward:
```
kubectl port-forward -n tidb-cluster svc/advanced-tidb-tidb 4000:4000
```

# Operator
1. Utilise image from PR adding tidb: quay.io/remerson/keycloak-operator:tidb

# Update Keycloak CR
1. Remove additional options db-driver
2. JDBC url: jdbc:mysql://advanced-tidb-tidb.tidb-cluster.svc.cluster.local:4000/keycloak?user=root
3. Remove username and password secrets
4. Vendor mysql
5. Image: quay.io/remerson/keycloak:tidb
6. Optional: Add `spi-user-sessions-infinispan-use-batches=false` in `spec.additionalOptions`
