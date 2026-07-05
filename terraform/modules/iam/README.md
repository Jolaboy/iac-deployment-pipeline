# IAM Module

Creates IAM roles for EKS control plane and worker nodes and attaches managed policies required for basic operation.

Inputs:
- `cluster_role_name`, `node_role_name`

Outputs:
- `eks_cluster_role_arn`, `eks_node_role_arn`
