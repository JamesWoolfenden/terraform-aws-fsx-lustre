output "file_system" {
  description = "The FSx for Lustre file system"
  value       = module.fsx_lustre.file_system
}

output "data_repository_association" {
  description = "The S3 data repository association, if created"
  value       = module.fsx_lustre.data_repository_association
}

output "file_cache" {
  description = "The Amazon File Cache, if created"
  value       = module.fsx_lustre.file_cache
}
