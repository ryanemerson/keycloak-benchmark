data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_availability_zones" "available_azs" {
  state = "available"
  filter {
    name   = "opt-in-status"
    # Currently, no support for Local Zones, Wavelength, or Outpost
    values = ["opt-in-not-required"]
  }
}

locals {
  supported_regions = {
    "ap-northeast-1" = "apne1"
    "ap-southeast-1" = "apse1"
    "ap-southeast-2" = "apse2"
    "ap-southeast-3" = "apse3"
    "ap-southeast-4" = "apse4"
    "ca-central-1"   = "cac1"
    "eu-central-1"   = "euc1"
    "eu-west-1"      = "euw1"
    "us-east-1"      = "use1"
    "us-east-2"      = "use2"
    "us-west-2"      = "usw2"
    "ap-south-2"     = "aps2"
  }
  well_known_az_ids = {
    us-east-1      = [2, 4, 6]
    ap-northeast-1 = [1, 2, 4]
  }
  azs      = slice(data.aws_availability_zones.available.names, 0, 1)
  # If an AZ has a single hyphen, it's an AZ ID
  az_ids   = [for az in local.azs : az if length(split("-", az)) == 2]
  # If an AZ has a two hyphens, it's an AZ name
  az_names = [for az in local.azs : az if length(split("-", az)) == 3]

  vpc_cidr_prefix = tonumber(split("/", var.vpc_cidr)[1])
  subnet_newbits  = var.subnet_cidr_prefix - local.vpc_cidr_prefix
  subnet_count    = var.private_subnets_only ? length(local.azs) : length(local.azs) * 2
}

# Performing multi-input validations in null_resource block
# https://github.com/hashicorp/terraform/issues/25609
resource "null_resource" "validations" {
  lifecycle {
    precondition {
      condition     = lookup(local.supported_regions, var.region, null) != null
      error_message = <<-EOT
        ROSA with hosted control planes is currently only available in these regions:
          ${join(", ", keys(local.supported_regions))}.
      EOT
    }

    precondition {
      condition     = local.vpc_cidr_prefix <= var.subnet_cidr_prefix
      error_message = "Subnet CIDR prefix must be smaller prefix (larger number) than the VPC CIDR prefix."
    }

    precondition {
      condition     = (length(local.az_ids) > 0 && length(local.az_names) == 0) || (length(local.az_ids) == 0 && length(local.az_names) > 0)
      error_message = <<-EOT
        Make sure to provide subnet_azs in either name format OR zone ID, do not mix and match.
          E.g., us-east-1a,us-east-1b OR use1-az1,use1-az2
      EOT
    }

    precondition {
      condition     = local.subnet_count <= pow(2, local.subnet_newbits)
      error_message = <<-EOT
        The size of available IP space is not enough to accomodate the expected number of subnets:
          Try increasing the size of your VPC CIDR, e.g., 10.0.0.0/16 -> 10.0.0.0/14
          Or try decreasing the size of your Subnet Prefix, e.g., 24 -> 28
      EOT
    }

    precondition {
      condition = alltrue([
        for name in local.az_names :contains(data.aws_availability_zones.available_azs.names, name)
      ])
      error_message = <<-EOT
        ROSA with hosted control planes in region ${var.region} does not currently support availability zone name(s):
          ${join(", ", [for name in local.az_names : name if !contains(data.aws_availability_zones.available_azs.names, name)])}
      EOT
    }

    precondition {
      condition = alltrue([
        for id in local.az_ids :contains(data.aws_availability_zones.available_azs.zone_ids, id)
      ])
      error_message = <<-EOT
        ROSA with hosted control planes in region ${var.region} does not currently support availability zone ID(s):
          ${join(", ", [for id in local.az_ids : id if !contains(data.aws_availability_zones.available_azs.zone_ids, id)])}
       EOT
    }
  }
}

module "account-roles" {
  source = "../modules/rosa/account-roles"

  account_role_prefix = var.account_role_prefix
  token               = var.token
  path                = var.path
}

module "operator-roles" {
  source = "../modules/rosa/oidc-provider-operator-roles"

  operator_role_prefix = var.operator_role_prefix
  path                 = var.path
  oidc_config          = "managed"
}

module "vpc" {
  source = "../modules/rosa/vpc"
  # This module doesn't really depend on these modules, but ensuring these are executed first lets us fail-fast if there
  # are issues with the roles and prevents us having to wait for a VPC to be provisioned before errors are reported
  depends_on = [module.account-roles,module.operator-roles]

  cluster_name = var.cluster_name
  region       = var.region
  subnet_azs   = local.azs
}

data "aws_caller_identity" "current" {
}

locals {
  account_role_path = coalesce(var.path, "/")
  sts_roles         = {
    role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.account_role_path}${var.account_role_prefix}-HCP-ROSA-Installer-Role",
    support_role_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.account_role_path}${var.account_role_prefix}-HCP-ROSA-Support-Role",
    instance_iam_roles = {
      worker_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.account_role_path}${var.account_role_prefix}-HCP-ROSA-Worker-Role"
    }
    operator_role_prefix = var.operator_role_prefix,
    oidc_config_id       = module.operator-roles.oidc_config_id
  }
}

resource "rhcs_cluster_rosa_hcp" "rosa_hcp_cluster" {
  name                   = var.cluster_name
  cloud_region           = var.region
  aws_account_id         = data.aws_caller_identity.current.account_id
  aws_billing_account_id = data.aws_caller_identity.current.account_id
  properties             = merge(
    {
      rosa_creator_arn = data.aws_caller_identity.current.arn
    },
  )

  aws_subnet_ids           = module.vpc.cluster-subnets
  wait_for_create_complete = true
  sts                      = local.sts_roles
  availability_zones       = local.azs
  version                  = var.openshift_version
}

resource "rhcs_cluster_wait" "rosa_cluster" {
  cluster = rhcs_cluster_rosa_hcp.rosa_hcp_cluster.id
  timeout = 30
}
