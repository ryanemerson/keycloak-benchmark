#!/usr/bin/env bash
set -e

if [[ "$RUNNER_DEBUG" == "1" ]]; then
  set -x
fi

if [ -f ./.env ]; then
  source ./.env
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CLUSTER_PREFIX=${CLUSTER_PREFIX:-$(whoami)}
if [ -z "$CLUSTER_PREFIX" ]; then echo "Variable CLUSTER_PREFIX needs to be set."; exit 1; fi

# Cleanup might fail if Aurora/EFS hasn't been configured for the cluster. Ignore any failures and continue
for AZ in "a" "b"; do
  export CLUSTER_NAME="${CLUSTER_PREFIX}-${AZ}"
  ./rds/aurora_delete_peering_connection.sh || true
  ./rosa_efs_delete.sh || true
done

cd ${SCRIPT_DIR}/../opentofu/modules/multi-az
./../../destroy.sh ${CLUSTER_PREFIX}
