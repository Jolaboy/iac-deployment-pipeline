variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "platform-core-production-cluster"
}

variable "ssh_key_name" {
  description = "SSH key name for node group remote access (optional)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type = map(string)
  default = {
    Environment = "Production"
    Owner       = "platform-team"
  }
}

## Backend placeholders (S3 + DynamoDB) - fill and uncomment in backend.tf
variable "remote_state_bucket" {
  description = "S3 bucket for terraform remote state (placeholder)"
  type        = string
  default     = "REPLACE_ME_TERRAFORM_STATE_BUCKET"
}

variable "remote_state_dynamodb_table" {
  description = "DynamoDB table name for state locking (placeholder)"
  type        = string
  default     = "REPLACE_ME_TF_LOCK_TABLE"
}
