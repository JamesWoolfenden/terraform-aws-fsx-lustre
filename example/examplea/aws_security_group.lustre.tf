resource "aws_security_group" "lustre" {
  name        = "fsx-lustre-examplea"
  description = "FSx for Lustre client access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Lustre LNET"
    from_port   = 988
    to_port     = 988
    protocol    = "tcp"
    cidr_blocks = var.client_cidrs
  }

  ingress {
    description = "Lustre"
    from_port   = 1018
    to_port     = 1023
    protocol    = "tcp"
    cidr_blocks = var.client_cidrs
  }

  egress {
    description = "Lustre clients"
    from_port   = 988
    to_port     = 1023
    protocol    = "tcp"
    cidr_blocks = var.client_cidrs
  }
}
