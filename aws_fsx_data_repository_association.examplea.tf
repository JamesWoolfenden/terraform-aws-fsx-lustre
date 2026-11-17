resource "aws_fsx_data_repository_association" "examplea" {
  count                            = var.data_repository_association == null ? 0 : 1
  file_system_id                   = aws_fsx_lustre_file_system.examplea.id
  data_repository_path             = var.data_repository_association.data_repository_path
  file_system_path                 = var.data_repository_association.file_system_path
  batch_import_meta_data_on_create = var.data_repository_association.batch_import_meta_data_on_create
  delete_data_in_filesystem        = var.data_repository_association.delete_data_in_filesystem

  s3 {
    auto_export_policy {
      events = var.data_repository_association.auto_export_events
    }

    auto_import_policy {
      events = var.data_repository_association.auto_import_events
    }
  }

  tags = var.common_tags
}
