# EKS Module

Creates EKS cluster, security groups and a managed node group. This module expects ARNs for roles created by the `iam` module and subnet ids from the `vpc` module.

Inputs:
- `cluster_name`, `cluster_role_arn`, `node_role_arn`, `subnet_ids`, `ssh_key_name`, `vpc_id`, `vpc_cidr`, `tags`

Outputs:
- `cluster_name`, `cluster_endpoint`
