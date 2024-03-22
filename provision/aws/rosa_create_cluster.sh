#!/usr/bin/env bash
set -e

if [ -f ./.env ]; then
  source ./.env
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

AWS_ACCOUNT=${AWS_ACCOUNT:-$(aws sts get-caller-identity --query "Account" --output text)}
if [ -z "$AWS_ACCOUNT" ]; then echo "Variable AWS_ACCOUNT needs to be set."; exit 1; fi

if [ -z "$VERSION" ]; then echo "Variable VERSION needs to be set."; exit 1; fi
CLUSTER_NAME=${CLUSTER_NAME:-$(whoami)}
if [ -z "$CLUSTER_NAME" ]; then echo "Variable CLUSTER_NAME needs to be set."; exit 1; fi
if [ -z "$REGION" ]; then echo "Variable REGION needs to be set."; exit 1; fi
if [ -z "$COMPUTE_MACHINE_TYPE" ]; then echo "Variable COMPUTE_MACHINE_TYPE needs to be set."; exit 1; fi

if [ "$MULTI_AZ" = "true" ]; then MULTI_AZ_PARAM="--multi-az"; else MULTI_AZ_PARAM=""; fi
if [ -z "$AVAILABILITY_ZONES" ]; then AVAILABILITY_ZONES_PARAM=""; else AVAILABILITY_ZONES_PARAM="--availability-zones $AVAILABILITY_ZONES"; fi
if [ -z "$REPLICAS" ]; then echo "Variable REPLICAS needs to be set."; exit 1; fi

echo "Checking if cluster ${CLUSTER_NAME} already exists."
if rosa describe cluster --cluster="${CLUSTER_NAME}"; then
  echo "Cluster ${CLUSTER_NAME} already exists."
else
  echo "Verifying ROSA prerequisites."
  echo "Check if AWS CLI is installed."; aws --version
  echo "Check if ROSA CLI is installed."; rosa version
  echo "Check if ELB service role is enabled."
  if ! aws iam get-role --role-name "AWSServiceRoleForElasticLoadBalancing" --no-cli-pager; then
    aws iam create-service-linked-role --aws-service-name "elasticloadbalancing.amazonaws.com"
  fi
  rosa whoami
  rosa verify quota

  echo "Installing ROSA cluster ${CLUSTER_NAME}"

  cd ${SCRIPT_DIR}/../opentofu/hcp
  tofu apply -var cluster_name=${CLUSTER_NAME} -var region=${REGION}
fi

mkdir -p "logs/${CLUSTER_NAME}"

function custom_date() {
    date '+%Y%m%d-%H%M%S'
}

./rosa_efs_create.sh
../infinispan/install_operator.sh

# cryostat operator depends on certmanager operator
./rosa_install_certmanager_operator.sh
./rosa_install_cryotstat_operator.sh

./rosa_install_openshift_logging.sh

echo "Cluster ${CLUSTER_NAME} is ready."
