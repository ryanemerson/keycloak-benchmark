#!/bin/bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAMESPACE=tidb-admin
VERSION=v1.6.3

kubectl create -f https://raw.githubusercontent.com/pingcap/tidb-operator/${VERSION}/manifests/crd.yaml || true
helm repo add pingcap https://charts.pingcap.org/
kubectl create namespace ${NAMESPACE}
helm install -n ${NAMESPACE} tidb-operator pingcap/tidb-operator --version ${VERSION}
kubectl -n ${NAMESPACE} rollout status deployment.apps/tidb-controller-manager
