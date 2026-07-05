Module usage notes

vpc module inputs:
- `vpc_cidr`, `public_subnet_cidr`, `private_subnet_cidr`, `public_az`, `private_az`, `tags`, `name_prefix`

iam module inputs:
- `cluster_role_name`, `node_role_name`

eks module inputs:
- `cluster_name`, `cluster_role_arn`, `node_role_arn`, `subnet_ids`, `ssh_key_name`, `vpc_id`, `vpc_cidr`, `tags`

See each module folder for more details.

Backend automation
- `terraform/deploy-backend-stack.sh` deploys the CloudFormation stack defined in `terraform/backend-stack.yml` to create the S3 bucket and DynamoDB table for remote state.
- After running the stack deployment, update `terraform/backend.tf` with the created bucket and table names and uncomment the backend block, then run `terraform init`.

GitHub environment
- `.github/create-environment.sh` is a template script using `gh` CLI to create the `production` environment and configure basic protection rules. Replace `{owner}/{repo}` placeholders before running.
