variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(string)

  validation {
    condition     = length(var.common_tags) > 0
    error_message = "common_tags must contain at least one tag."
  }
}

variable "vpc_id" {
  description = "VPC to deploy into"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "vpc_id must be a VPC ID such as vpc-0123456789abcdef0."
  }
}

variable "subnet_ids" {
  description = "Subnets to deploy into"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0 && alltrue([for s in var.subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", s))])
    error_message = "subnet_ids must be a non-empty list of subnet IDs."
  }
}

variable "client_cidrs" {
  description = "Private CIDR ranges allowed to mount the file system"
  type        = list(string)

  validation {
    condition     = length(var.client_cidrs) > 0 && alltrue([for c in var.client_cidrs : can(cidrhost(c, 0)) && c != "0.0.0.0/0"])
    error_message = "client_cidrs must be valid CIDR blocks and must not include 0.0.0.0/0."
  }
}

variable "data_repository_path" {
  description = "S3 path to link, e.g. s3://bucket/prefix"
  type        = string

  validation {
    condition     = can(regex("^s3://[a-z0-9.-]{3,63}(/.*)?$", var.data_repository_path))
    error_message = "data_repository_path must be an S3 URI such as s3://bucket/prefix."
  }
}
