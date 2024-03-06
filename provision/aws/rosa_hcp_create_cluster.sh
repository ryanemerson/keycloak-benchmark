#!/usr/bin/env bash
set -e

if [ -f ./.env ]; then
  source ./.env
fi

if [[ "$RUNNER_DEBUG" == "1" ]]; then
  set -x
fi

AWS_ACCOUNT=${AWS_ACCOUNT:-$(aws sts get-caller-identity --query "Account" --output text)}
if [ -z "$AWS_ACCOUNT" ]; then echo "Variable AWS_ACCOUNT needs to be set."; exit 1; fi

if [ -z "$VERSION" ]; then echo "Variable VERSION needs to be set."; exit 1; fi
CLUSTER_NAME=${CLUSTER_NAME:-$(whoami)}
if [ -z "$CLUSTER_NAME" ]; then echo "Variable CLUSTER_NAME needs to be set."; exit 1; fi
if [ -z "$REGION" ]; then echo "Variable REGION needs to be set."; exit 1; fi
if [ -z "$COMPUTE_MACHINE_TYPE" ]; then echo "Variable COMPUTE_MACHINE_TYPE needs to be set."; exit 1; fi

if [ -z "$AVAILABILITY_ZONES" ]; then AVAILABILITY_ZONES_PARAM=""; else AVAILABILITY_ZONES_PARAM="--availability-zones $AVAILABILITY_ZONES"; fi

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

  OPERATOR_ROLES_PREFIX="kcb"
  export AWS_REGION=${REGION}
  # Each region may have different availability-zones, so we need to ensure that we use an az that exists
  IFS='	' read -a AZS <<< "$(aws ec2 describe-availability-zones --query "AvailabilityZones[].ZoneName" --output text)"

  rosa create account-roles --hosted-cp --prefix ${OPERATOR_ROLES_PREFIX} --mode auto
  OIDC_ID=$(rosa create oidc-config --mode=auto --yes -o json | jq -r .id)
  rosa create operator-roles \
    --hosted-cp \
    --prefix ${OPERATOR_ROLES_PREFIX} \
    --oidc-config-id ${OIDC_ID} \
    --installer-role-arn arn:aws:iam::${AWS_ACCOUNT}:role/${OPERATOR_ROLES_PREFIX}-HCP-ROSA-Installer-Role \
    --mode auto \
    --yes

  # TODO is use of /24 instead of /16 an issue?
  MACHINE_CIDR=$(./rosa_machine_cidr.sh)
  PRIVATE_SUBNET_CIDR="${MACHINE_CIDR%.*}.0/26"
  PUBLIC_SUBNET_CIDR="${MACHINE_CIDR%.*}.128/26"

  HCP_VPC=$(aws ec2 create-vpc \
    --cidr-block ${MACHINE_CIDR} \
    --tag-specifications "ResourceType=vpc, Tags=[{Key=Name,Value=${CLUSTER_NAME}}]" \
    --query "Vpc.VpcId" \
    --output text
  )

  HCP_PRIVATE_ROUTE_TABLE_ID=$(aws ec2 create-route-table \
    --vpc-id ${HCP_VPC} \
    --tag-specifications "ResourceType=route-table, Tags=[{Key=Name,Value=${CLUSTER_NAME}-private}]" \
    --query "RouteTable.RouteTableId" \
    --output text
  )

  # TODO
  # TODO add Name tag
  PRIVATE_SUBNET=$(aws ec2 create-subnet \
    --availability-zone "${AZS[0]}" \
    --vpc-id ${HCP_VPC} \
    --cidr-block ${PRIVATE_SUBNET_CIDR} \
    --tag-specifications "ResourceType=subnet, Tags=[{Key=Name,Value=${CLUSTER_NAME}-private}]" \
    --query "Subnet.SubnetId" \
    --output text
  )

  IP_ALLOCATION=$(aws ec2 allocate-address \
    --domain ${HCP_VPC} \
    --query "AllocationId" \
    --output text
  )

  NAT_GATEWAY=$(aws ec2 create-nat-gateway \
    --allocation-id ${IP_ALLOCATION} \
    --subnet-id ${PRIVATE_SUBNET} \
    --tag-specifications "ResourceType=natgateway, Tags=[{Key=Name,Value=${CLUSTER_NAME}-private}]" \
    --query "NatGateway.NatGatewayId" \
    --output text
  )

  aws ec2 associate-route-table \
    --route-table-id ${HCP_PRIVATE_ROUTE_TABLE_ID} \
    --subnet-id ${PRIVATE_SUBNET}

  aws ec2 create-route \
    --route-table-id ${HCP_PRIVATE_ROUTE_TABLE_ID} \
    --destination-cidr-block 0.0.0.0/0 \
    --nat-gateway-id ${NAT_GATEWAY}

  # TODO
  # TODO add Name tag
  PUBLIC_SUBNET=$(aws ec2 create-subnet \
    --availability-zone "${AZS[0]}" \
    --vpc-id ${HCP_VPC} \
    --cidr-block ${PUBLIC_SUBNET_CIDR} \
    --tag-specifications "ResourceType=subnet, Tags=[{Key=Name,Value=${CLUSTER_NAME}-public}]" \
    --query "Subnet.SubnetId" \
    --output text
  )

  INTERNET_GATEWAY=$(aws ec2 create-internet-gateway \
    --tag-specifications "ResourceType=internet-gateway, Tags=[{Key=Name,Value=${CLUSTER_NAME}}]" \
    --query "InternetGateway.InternetGatewayId" \
    --output text
  )

  aws ec2 attach-internet-gateway \
    --internet-gateway-id ${INTERNET_GATEWAY} \
    --vpc-id ${HCP_VPC}

  HCP_PUBLIC_ROUTE_TABLE_ID=$(aws ec2 create-route-table \
    --vpc-id ${HCP_VPC} \
    --tag-specifications "ResourceType=route-table, Tags=[{Key=Name,Value=${CLUSTER_NAME}-public}]" \
    --query "RouteTable.RouteTableId" \
    --output text
  )

  aws ec2 associate-route-table \
    --route-table-id ${HCP_PUBLIC_ROUTE_TABLE_ID} \
    --subnet-id ${PUBLIC_SUBNET}

  aws ec2 create-route \
    --route-table-id ${HCP_PUBLIC_ROUTE_TABLE_ID} \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id ${INTERNET_GATEWAY}

  # Enable DNS hostnames on VPC
  aws ec2 modify-vpc-attribute  \
    --vpc-id ${HCP_VPC} \
    --enable-dns-hostnames

# Hardcode terra values to get working HCP cluster
#  HCP_VPC=vpc-089ab75baa9e44407
#  MACHINE_CIDR=10.0.0.0/16
#  PRIVATE_SUBNET=subnet-0f0e3f666b99de3e1
#  PUBLIC_SUBNET=subnet-0f29de94bc306226e

  ROSA_CMD="rosa create cluster \
  --sts \
  --mode auto \
  --hosted-cp \
  --cluster-name ${CLUSTER_NAME} \
  --version ${VERSION} \
  --operator-roles-prefix ${OPERATOR_ROLES_PREFIX} \
  --oidc-config-id ${OIDC_ID} \
  --region ${REGION} \
  --compute-machine-type ${COMPUTE_MACHINE_TYPE} \
  --machine-cidr ${MACHINE_CIDR} \
  --subnet-ids ${PRIVATE_SUBNET},${PUBLIC_SUBNET}"


  echo $ROSA_CMD
  $ROSA_CMD
fi

mkdir -p "logs/${CLUSTER_NAME}"

function custom_date() {
    date '+%Y%m%d-%H%M%S'
}

#echo "Creating operator roles."
#rosa create operator-roles --cluster "${CLUSTER_NAME}" --mode auto --yes > "logs/${CLUSTER_NAME}/$(custom_date)_create-operator-roles.log"
#
#echo "Creating OIDC provider."
#rosa create oidc-provider --cluster "${CLUSTER_NAME}" --mode auto --yes > "logs/${CLUSTER_NAME}/$(custom_date)_create-oidc-provider.log"
#
echo "Waiting for cluster installation to finish."
# There have been failures with 'ERR: Failed to watch logs for cluster ... connection reset by peer' probably because services in the cluster were restarting during the cluster initialization.
# Those errors don't show an installation problem, and installation will continue asynchronously. Therefore, retry.
TIMEOUT=$(($(date +%s) + 3600))
while true ; do
  if (rosa logs install --cluster "${CLUSTER_NAME}" --watch --tail=1000000 >> "logs/${CLUSTER_NAME}/$(custom_date)_create-cluster.log"); then
    break
  fi
  if (( TIMEOUT < $(date +%s))); then
    echo "Timeout exceeded"
    exit 1
  fi
  echo "retrying watching logs after failure"
  sleep 1
done

echo "Cluster installation complete."
echo

./rosa_recreate_admin.sh

#SCALING_MACHINE_POOL=$(rosa list machinepools -c "${CLUSTER_NAME}" -o json | jq -r '.[] | select(.id == "scaling") | .id')
#if [[ "${SCALING_MACHINE_POOL}" != "scaling" ]]; then
#    rosa create machinepool -c "${CLUSTER_NAME}" --instance-type m5.4xlarge --max-replicas 10 --min-replicas 0 --name scaling --enable-autoscaling
#fi
#
#./rosa_efs_create.sh
#../infinispan/install_operator.sh
#
## cryostat operator depends on certmanager operator
#./rosa_install_certmanager_operator.sh
#./rosa_install_cryotstat_operator.sh
#
#./rosa_install_openshift_logging.sh
#
#echo "Cluster ${CLUSTER_NAME} is ready."
