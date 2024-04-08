#!/usr/bin/env bash
set -e

if [[ "$RUNNER_DEBUG" == "1" ]]; then
  set -x
fi

if [ -f ./.env ]; then
  source ./.env
fi

function requiredEnv() {
  for ENV in $@; do
      if [ -z "${!ENV}" ]; then
        echo "${ENV} variable must be set"
        exit 1
      fi
  done
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

AWS_ACCOUNT=${AWS_ACCOUNT:-$(aws sts get-caller-identity --query "Account" --output text)}

requiredEnv AWS_ACCOUNT CLUSTER_PREFIX REGION

export CLUSTER_PREFIX=${CLUSTER_PREFIX:-$(whoami)}

echo "Verifying ROSA prerequisites."
echo "Check if AWS CLI is installed."; aws --version
echo "Check if ROSA CLI is installed."; rosa version
echo "Check if ELB service role is enabled."
# TODO add to terraform module
if ! aws iam get-role --role-name "AWSServiceRoleForElasticLoadBalancing" --no-cli-pager; then
  aws iam create-service-linked-role --aws-service-name "elasticloadbalancing.amazonaws.com"
fi
rosa whoami
rosa verify quota

cd ${SCRIPT_DIR}/../opentofu/modules/multi-az/clusters
tofu init
tofu workspace new ${CLUSTER_PREFIX} || true
export TF_WORKSPACE=${CLUSTER_PREFIX}

TOFU_CMD="tofu apply -auto-approve \
  -var cluster_prefix=${CLUSTER_PREFIX} \
  -var region=${REGION}"

if [ -n "${COMPUTE_MACHINE_TYPE}" ]; then
  TOFU_CMD+=" -var instance_type=${COMPUTE_MACHINE_TYPE}"
fi

if [ -n "${VERSION}" ]; then
  TOFU_CMD+=" -var openshift_version=${VERSION}"
fi

if [ -n "${REPLICAS}" ]; then
  TOFU_CMD+=" -var replicas=${REPLICAS}"
fi

echo ${TOFU_CMD}
${TOFU_CMD}
