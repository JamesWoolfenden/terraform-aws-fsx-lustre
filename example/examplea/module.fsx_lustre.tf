# holden:ignore:HLD_TF_026 the example intentionally calls the module under test via ../../ so it always exercises the working tree
module "fsx_lustre" {
  source             = "../../"
  common_tags        = var.common_tags
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.lustre.id]
  kms_key_id         = aws_kms_key.examplea.arn

  log_configuration = {
    level       = "WARN_ERROR"
    destination = aws_cloudwatch_log_group.lustre.arn
  }

  data_repository_association = {
    data_repository_path = var.data_repository_path
    file_system_path     = "/data"
  }

  file_cache = {
    data_repository_associations = [{
      data_repository_path = var.data_repository_path
      file_cache_path      = "/cache"
    }]
  }
}
