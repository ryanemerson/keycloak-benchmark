variable "rhcs_token" {
  type      = string
  sensitive = true
}

variable "region" {
  description = <<-EOT
    Region to create AWS infrastructure resources for a
      ROSA with hosted control planes cluster. (required)
  EOT
  type        = string
}

variable "cluster_prefix" {
  description = "The prefix to be used when creating HCP clusters."
  type        = string

  validation {
    condition     = can(regex("^[a-z][-a-z0-9]{0,11}[a-z0-9]$", var.cluster_prefix))
    error_message = <<-EOT
      Prefix must be less than 14 characters.
        May only contain lower case, alphanumeric, or hyphens characters.
    EOT
  }
}

variable "openshift_version" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = null
}

variable "replicas" {
  type    = number
  default = null
}
