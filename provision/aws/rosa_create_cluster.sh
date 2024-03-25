#!/usr/bin/env bash
set -e

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

requiredEnv AWS_ACCOUNT COMPUTE_MACHINE_TYPE CLUSTER_NAME REGION REPLICAS VERSION

CLUSTER_NAME=${CLUSTER_NAME:-$(whoami)}

if [ "$MULTI_AZ" = "true" ]; then MULTI_AZ_PARAM="--multi-az"; else MULTI_AZ_PARAM=""; fi
if [ -z "$AVAILABILITY_ZONES" ]; then AVAILABILITY_ZONES_PARAM=""; else AVAILABILITY_ZONES_PARAM="--availability-zones $AVAILABILITY_ZONES"; fi

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
tofu init
tofu workspace new ${CLUSTER_NAME} || true
export TF_WORKSPACE=${CLUSTER_NAME}
tofu apply -auto-approve \
  -var cluster_name=${CLUSTER_NAME} \
  -var instance_type=${COMPUTE_MACHINE_TYPE} \
  -var openshift_version=${VERSION} \
  -var region=${REGION} \
  -var replicas=${REPLICAS}

mkdir -p "logs/${CLUSTER_NAME}"

function custom_date() {
    date '+%Y%m%d-%H%M%S'
}

cd ${SCRIPT_DIR}
../infinispan/install_operator.sh

# cryostat operator depends on certmanager operator
./rosa_install_certmanager_operator.sh
./rosa_install_cryotstat_operator.sh

./rosa_install_openshift_logging.sh

echo "Cluster ${CLUSTER_NAME} is ready."
