output "file_system" {
  description = "The FSx for Lustre file system"
  value       = aws_fsx_lustre_file_system.examplea
}

output "data_repository_association" {
  description = "The S3 data repository association, if created"
  value       = aws_fsx_data_repository_association.examplea
}

output "file_cache" {
  description = "The Amazon File Cache, if created"
  value       = aws_fsx_file_cache.examplea
}
