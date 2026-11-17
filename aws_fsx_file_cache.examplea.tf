resource "aws_fsx_file_cache" "examplea" {
  count                                     = var.file_cache == null ? 0 : 1
  file_cache_type                           = "LUSTRE"
  file_cache_type_version                   = var.file_cache.file_cache_type_version
  storage_capacity                          = var.file_cache.storage_capacity
  subnet_ids                                = var.subnet_ids
  security_group_ids                        = var.security_group_ids
  kms_key_id                                = var.kms_key_id
  copy_tags_to_data_repository_associations = true

  lustre_configuration {
    deployment_type               = "CACHE_1"
    per_unit_storage_throughput   = var.file_cache.per_unit_storage_throughput
    weekly_maintenance_start_time = var.weekly_maintenance_start_time

    metadata_configuration {
      storage_capacity = var.file_cache.metadata_storage_capacity
    }
  }

  dynamic "data_repository_association" {
    for_each = var.file_cache.data_repository_associations
    content {
      data_repository_path           = data_repository_association.value.data_repository_path
      file_cache_path                = data_repository_association.value.file_cache_path
      data_repository_subdirectories = data_repository_association.value.data_repository_subdirectories
    }
  }

  tags = var.common_tags
}
