resource "aws_cloudwatch_log_group" "lustre" {
  # FSx for Lustre requires the log group name to start with /aws/fsx/
  name                        = "/aws/fsx/lustre-examplea"
  retention_in_days           = 365
  kms_key_id                  = aws_kms_key.examplea.arn
  deletion_protection_enabled = true
}
