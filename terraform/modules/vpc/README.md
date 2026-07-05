# VPC Module

Provides:
- VPC, public and private subnet
- Internet Gateway, NAT Gateway
- Public and private route tables

Inputs:
- `vpc_cidr`, `public_subnet_cidr`, `private_subnet_cidr`, `public_az`, `private_az`, `tags`, `name_prefix`

Outputs:
- `vpc_id`, `public_subnet_id`, `private_subnet_id`
