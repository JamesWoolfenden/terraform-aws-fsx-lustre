resource "aws_fsx_lustre_file_system" "examplea" {
  storage_capacity                  = var.file_system.storage_capacity
  storage_type                      = var.file_system.storage_type
  subnet_ids                        = var.subnet_ids
  security_group_ids                = var.security_group_ids
  deployment_type                   = var.file_system.deployment_type
  per_unit_storage_throughput       = var.file_system.per_unit_storage_throughput
  file_system_type_version          = var.file_system.file_system_type_version
  data_compression_type             = var.file_system.data_compression_type
  kms_key_id                        = var.kms_key_id
  automatic_backup_retention_days   = var.automatic_backup_retention_days
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  weekly_maintenance_start_time     = var.weekly_maintenance_start_time
  copy_tags_to_backups              = var.copy_tags_to_backups
  skip_final_backup                 = var.skip_final_backup
  final_backup_tags                 = var.common_tags

  log_configuration {
    level       = var.log_configuration.level
    destination = var.log_configuration.destination
  }

  root_squash_configuration {
    root_squash    = var.root_squash_configuration.root_squash
    no_squash_nids = var.root_squash_configuration.no_squash_nids
  }

  dynamic "metadata_configuration" {
    for_each = var.metadata_configuration == null ? [] : [var.metadata_configuration]
    content {
      mode = metadata_configuration.value.mode
      iops = metadata_configuration.value.iops
    }
  }

  tags = var.common_tags
}
