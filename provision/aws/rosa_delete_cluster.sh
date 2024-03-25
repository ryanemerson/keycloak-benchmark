#!/usr/bin/env bash
set -e

if [[ "$RUNNER_DEBUG" == "1" ]]; then
  set -x
fi

if [ -f ./.env ]; then
  source ./.env
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CLUSTER_NAME=${CLUSTER_NAME:-$(whoami)}
if [ -z "$CLUSTER_NAME" ]; then echo "Variable CLUSTER_NAME needs to be set."; exit 1; fi

# Cleanup might fail if Aurora/EFS hasn't been configured for the cluster. Ignore any failures and continue
./rds/aurora_delete_peering_connection.sh || true

function custom_date() {
    echo "$(date '+%Y%m%d-%H%M%S')"
}

CLUSTER_ID=$(rosa describe cluster --cluster "$CLUSTER_NAME" | grep -oPm1 "^ID:\s*\K\w+")
echo "CLUSTER_ID: $CLUSTER_ID"

cd ${SCRIPT_DIR}/../opentofu/hcp
./../destroy.sh ${CLUSTER_NAME}

mkdir -p "logs/${CLUSTER_NAME}"
