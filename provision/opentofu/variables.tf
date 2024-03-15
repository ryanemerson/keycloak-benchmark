variable "region" {
  description = <<-EOT
    Region to create AWS infrastructure resources for a
      ROSA with hosted control planes cluster. (required)
  EOT
  type        = string
}

variable "cluster_name" {
  description = "Name of the created ROSA with hosted control planes cluster."
  type        = string
  default     = "rosa-hcp"

  validation {
    condition     = can(regex("^[a-z][-a-z0-9]{0,13}[a-z0-9]$", var.cluster_name))
    error_message = <<-EOT
      ROSA cluster names must be less than 16 characters.
        May only contain lower case, alphanumeric, or hyphens characters.
    EOT
  }
}
