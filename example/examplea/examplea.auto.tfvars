common_tags = {
  "createdby" = "terraform"
  module      = "terraform-aws-fsx-lustre"
}
vpc_id               = "vpc-0123456789abcdef0"
subnet_ids           = ["subnet-04338b6369d8288a5"]
client_cidrs         = ["10.0.0.0/16"]
data_repository_path = "s3://examplea-fsx-lustre/data"
