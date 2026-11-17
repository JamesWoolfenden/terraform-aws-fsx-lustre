variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(string)

  validation {
    condition     = length(var.common_tags) > 0
    error_message = "common_tags must contain at least one tag."
  }
}

variable "subnet_ids" {
  description = "Subnet IDs for the file system (Lustre supports a single subnet)"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) == 1 && can(regex("^subnet-[0-9a-f]{8,17}$", var.subnet_ids[0]))
    error_message = "subnet_ids must contain exactly one subnet ID."
  }
}

variable "security_group_ids" {
  description = "Security groups to attach to the file system network interfaces"
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) > 0 && alltrue([for s in var.security_group_ids : can(regex("^sg-[0-9a-f]{8,17}$", s))])
    error_message = "At least one security group ID (sg-...) must be supplied."
  }
}

variable "kms_key_id" {
  description = "ARN of the customer managed KMS key used to encrypt data at rest (file system and file cache)"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/.+$", var.kms_key_id))
    error_message = "kms_key_id must be a customer managed KMS key ARN."
  }
}

variable "file_system" {
  description = "Core Lustre file system settings"
  type = object({
    storage_capacity            = optional(number, 1200)
    storage_type                = optional(string, "SSD")
    deployment_type             = optional(string, "PERSISTENT_2")
    per_unit_storage_throughput = optional(number, 125)
    file_system_type_version    = optional(string, "2.15")
    data_compression_type       = optional(string, "LZ4")
  })
  default = {}

  validation {
    condition     = contains(["PERSISTENT_1", "PERSISTENT_2"], var.file_system.deployment_type)
    error_message = "Only PERSISTENT deployment types are allowed (SCRATCH types do not support backups or CMK encryption)."
  }

  validation {
    condition     = contains(["SSD", "HDD", "INTELLIGENT_TIERING"], var.file_system.storage_type)
    error_message = "storage_type must be SSD, HDD or INTELLIGENT_TIERING."
  }

  validation {
    condition     = contains(["NONE", "LZ4"], var.file_system.data_compression_type)
    error_message = "data_compression_type must be NONE or LZ4."
  }

  validation {
    condition     = var.file_system.storage_capacity >= 1200
    error_message = "storage_capacity must be at least 1200 GiB."
  }
}

variable "automatic_backup_retention_days" {
  description = "Days to retain automatic backups"
  type        = number
  default     = 7

  validation {
    condition     = var.automatic_backup_retention_days >= 1 && var.automatic_backup_retention_days <= 90
    error_message = "Automatic backups must be enabled with a retention of 1-90 days."
  }
}

variable "daily_automatic_backup_start_time" {
  description = "Daily backup start time in HH:MM (UTC)"
  type        = string
  default     = "01:00"

  validation {
    condition     = can(regex("^([01][0-9]|2[0-3]):[0-5][0-9]$", var.daily_automatic_backup_start_time))
    error_message = "daily_automatic_backup_start_time must be HH:MM."
  }
}

variable "weekly_maintenance_start_time" {
  description = "Weekly maintenance window in d:HH:MM (UTC)"
  type        = string
  default     = "7:03:00"

  validation {
    condition     = can(regex("^[1-7]:([01][0-9]|2[0-3]):[0-5][0-9]$", var.weekly_maintenance_start_time))
    error_message = "weekly_maintenance_start_time must be d:HH:MM."
  }
}

variable "copy_tags_to_backups" {
  description = "Copy file system tags to backups"
  type        = bool
  default     = true
}

variable "skip_final_backup" {
  description = "Skip the final backup on deletion"
  type        = bool
  default     = false
}

variable "log_configuration" {
  description = "Lustre logging to CloudWatch. level: WARN_ONLY, ERROR_ONLY or WARN_ERROR. destination: CloudWatch log group ARN (null uses /aws/fsx/lustre)"
  type = object({
    level       = optional(string, "WARN_ERROR")
    destination = optional(string)
  })
  default = {}

  validation {
    condition     = contains(["WARN_ONLY", "ERROR_ONLY", "WARN_ERROR"], var.log_configuration.level)
    error_message = "Logging must be enabled: level must be WARN_ONLY, ERROR_ONLY or WARN_ERROR."
  }
}

variable "root_squash_configuration" {
  description = "Root squash settings, maps root (UID 0) to an unprivileged UID:GID"
  type = object({
    root_squash    = optional(string, "65534:65534")
    no_squash_nids = optional(list(string), [])
  })
  default = {}

  validation {
    condition     = can(regex("^[0-9]+:[0-9]+$", var.root_squash_configuration.root_squash)) && var.root_squash_configuration.root_squash != "0:0"
    error_message = "root_squash must be UID:GID and must not be 0:0."
  }
}

variable "metadata_configuration" {
  description = "Metadata configuration (PERSISTENT_2 only). null leaves the provider default"
  type = object({
    mode = optional(string, "AUTOMATIC")
    iops = optional(number)
  })
  default = null

  validation {
    condition     = var.metadata_configuration == null || contains(["AUTOMATIC", "USER_PROVISIONED"], try(var.metadata_configuration.mode, ""))
    error_message = "metadata_configuration.mode must be AUTOMATIC or USER_PROVISIONED."
  }
}

variable "data_repository_association" {
  description = "Optional S3 data repository association (PERSISTENT_2 only). null disables"
  type = object({
    data_repository_path             = string
    file_system_path                 = string
    batch_import_meta_data_on_create = optional(bool, false)
    delete_data_in_filesystem        = optional(bool, false)
    auto_export_events               = optional(list(string), ["NEW", "CHANGED", "DELETED"])
    auto_import_events               = optional(list(string), ["NEW", "CHANGED", "DELETED"])
  })
  default = null

  validation {
    condition     = var.data_repository_association == null || (can(regex("^s3://", try(var.data_repository_association.data_repository_path, ""))) && startswith(try(var.data_repository_association.file_system_path, ""), "/"))
    error_message = "data_repository_path must be an s3:// URI and file_system_path must start with /."
  }
}

variable "file_cache" {
  description = "Optional Amazon File Cache (Lustre based). null disables"
  type = object({
    file_cache_type_version     = optional(string, "2.12")
    storage_capacity            = optional(number, 1200)
    per_unit_storage_throughput = optional(number, 1000)
    metadata_storage_capacity   = optional(number, 2400)
    data_repository_associations = list(object({
      data_repository_path           = string
      file_cache_path                = string
      data_repository_subdirectories = optional(list(string))
    }))
  })
  default = null

  validation {
    condition     = var.file_cache == null || (length(try(var.file_cache.data_repository_associations, [])) >= 1 && length(try(var.file_cache.data_repository_associations, [])) <= 8)
    error_message = "file_cache requires between 1 and 8 data repository associations."
  }
}
