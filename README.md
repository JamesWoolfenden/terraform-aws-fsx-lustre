# terraform-aws-fsx-lustre

[![Build Status](https://github.com/JamesWoolfenden/terraform-aws-fsx-lustre/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-aws-fsx-lustre)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-aws-fsx-lustre.svg)](https://github.com/JamesWoolfenden/terraform-aws-fsx-lustre/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-aws-fsx-lustre.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-aws-fsx-lustre/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for an Amazon FSx for Lustre file system, with an optional S3 data repository association and optional Amazon File Cache. Secure defaults: PERSISTENT_2 deployment, customer managed KMS key required, CloudWatch logging (WARN_ERROR), automatic backups (7 days) with final backup on delete, root squash enabled.

---

It's 100% Open Source and licensed under the [APACHE2](LICENSE).

## Usage

Include this repository as a module in your existing Terraform code:

```hcl
module "fsx_lustre" {
  source             = "JamesWoolfenden/fsx-lustre/aws"
  version            = "0.0.1"
  common_tags        = var.common_tags
  subnet_ids         = ["subnet-04338b6369d8288a5"]
  security_group_ids = [aws_security_group.lustre.id]
  kms_key_id         = aws_kms_key.examplea.arn
}
```

The example in the **examplea** folder creates the supporting KMS key, log group and security group.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_fsx_data_repository_association.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_data_repository_association) | resource |
| [aws_fsx_file_cache.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_file_cache) | resource |
| [aws_fsx_lustre_file_system.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_lustre_file_system) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_automatic_backup_retention_days"></a> [automatic\_backup\_retention\_days](#input\_automatic\_backup\_retention\_days) | Days to retain automatic backups | `number` | `7` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | This is to help you add tags to your cloud objects | `map(string)` | n/a | yes |
| <a name="input_copy_tags_to_backups"></a> [copy\_tags\_to\_backups](#input\_copy\_tags\_to\_backups) | Copy file system tags to backups | `bool` | `true` | no |
| <a name="input_daily_automatic_backup_start_time"></a> [daily\_automatic\_backup\_start\_time](#input\_daily\_automatic\_backup\_start\_time) | Daily backup start time in HH:MM (UTC) | `string` | `"01:00"` | no |
| <a name="input_data_repository_association"></a> [data\_repository\_association](#input\_data\_repository\_association) | Optional S3 data repository association (PERSISTENT\_2 only). null disables | <pre>object({<br/>    data_repository_path             = string<br/>    file_system_path                 = string<br/>    batch_import_meta_data_on_create = optional(bool, false)<br/>    delete_data_in_filesystem        = optional(bool, false)<br/>    auto_export_events               = optional(list(string), ["NEW", "CHANGED", "DELETED"])<br/>    auto_import_events               = optional(list(string), ["NEW", "CHANGED", "DELETED"])<br/>  })</pre> | `null` | no |
| <a name="input_file_cache"></a> [file\_cache](#input\_file\_cache) | Optional Amazon File Cache (Lustre based). null disables | <pre>object({<br/>    file_cache_type_version     = optional(string, "2.12")<br/>    storage_capacity            = optional(number, 1200)<br/>    per_unit_storage_throughput = optional(number, 1000)<br/>    metadata_storage_capacity   = optional(number, 2400)<br/>    data_repository_associations = list(object({<br/>      data_repository_path           = string<br/>      file_cache_path                = string<br/>      data_repository_subdirectories = optional(list(string))<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_file_system"></a> [file\_system](#input\_file\_system) | Core Lustre file system settings | <pre>object({<br/>    storage_capacity            = optional(number, 1200)<br/>    storage_type                = optional(string, "SSD")<br/>    deployment_type             = optional(string, "PERSISTENT_2")<br/>    per_unit_storage_throughput = optional(number, 125)<br/>    file_system_type_version    = optional(string, "2.15")<br/>    data_compression_type       = optional(string, "LZ4")<br/>  })</pre> | `{}` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | ARN of the customer managed KMS key used to encrypt data at rest (file system and file cache) | `string` | n/a | yes |
| <a name="input_log_configuration"></a> [log\_configuration](#input\_log\_configuration) | Lustre logging to CloudWatch. level: WARN\_ONLY, ERROR\_ONLY or WARN\_ERROR. destination: CloudWatch log group ARN (null uses /aws/fsx/lustre) | <pre>object({<br/>    level       = optional(string, "WARN_ERROR")<br/>    destination = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_metadata_configuration"></a> [metadata\_configuration](#input\_metadata\_configuration) | Metadata configuration (PERSISTENT\_2 only). null leaves the provider default | <pre>object({<br/>    mode = optional(string, "AUTOMATIC")<br/>    iops = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_root_squash_configuration"></a> [root\_squash\_configuration](#input\_root\_squash\_configuration) | Root squash settings, maps root (UID 0) to an unprivileged UID:GID | <pre>object({<br/>    root_squash    = optional(string, "65534:65534")<br/>    no_squash_nids = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups to attach to the file system network interfaces | `list(string)` | n/a | yes |
| <a name="input_skip_final_backup"></a> [skip\_final\_backup](#input\_skip\_final\_backup) | Skip the final backup on deletion | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for the file system (Lustre supports a single subnet) | `list(string)` | n/a | yes |
| <a name="input_weekly_maintenance_start_time"></a> [weekly\_maintenance\_start\_time](#input\_weekly\_maintenance\_start\_time) | Weekly maintenance window in d:HH:MM (UTC) | `string` | `"7:03:00"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_data_repository_association"></a> [data\_repository\_association](#output\_data\_repository\_association) | The S3 data repository association, if created |
| <a name="output_file_cache"></a> [file\_cache](#output\_file\_cache) | The Amazon File Cache, if created |
| <a name="output_file_system"></a> [file\_system](#output\_file\_system) | The FSx for Lustre file system |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Policy

This is the policy required to build this project:

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role — full permissions for terraform apply
resource "aws_iam_policy" "terraform_pike" {
  name_prefix = "terraform_pike"
  path        = "/"
  description = "Pike Autogenerated policy from IAC"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVpcs"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "fsx:CreateDataRepositoryAssociation",
                "fsx:CreateFileCache",
                "fsx:CreateFileSystem",
                "fsx:DeleteDataRepositoryAssociation",
                "fsx:DeleteFileCache",
                "fsx:DeleteFileSystem",
                "fsx:DescribeDataRepositoryAssociations",
                "fsx:DescribeFileCaches",
                "fsx:DescribeFileSystems",
                "fsx:ListTagsForResource",
                "fsx:TagResource",
                "fsx:UntagResource",
                "fsx:UpdateDataRepositoryAssociation",
                "fsx:UpdateFileCache",
                "fsx:UpdateFileSystem"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "iam:AttachRolePolicy",
                "iam:CreateServiceLinkedRole",
                "iam:PutRolePolicy"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketPolicy",
                "s3:ListBucket",
                "s3:PutBucketPolicy"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
})
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Related Projects

Check out these related projects.

- [terraform-aws-fsx-openzfs](https://github.com/jameswoolfenden/terraform-aws-fsx-openzfs) - FSx for OpenZFS

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-aws-fsx-lustre/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/JamesWoolfenden/terraform-aws-fsx-lustre/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2019-2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
