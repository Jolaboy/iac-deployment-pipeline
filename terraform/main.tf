// Root Terraform now composes purpose-built modules: vpc, iam, eks

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr          = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  tags = var.tags
}

module "iam" {
  source = "./modules/iam"

  cluster_role_name = "${var.cluster_name}-cluster-role"
  node_role_name    = "${var.cluster_name}-node-role"
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_role_arn
  subnet_ids         = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]
  ssh_key_name       = var.ssh_key_name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

