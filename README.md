# Automated Infrastructure-as-Code Deployment Pipeline (`iac-deployment-pipeline`)

Enterprise-grade platform engineering repository with modular Terraform for a secure multi-tier AWS VPC and a managed EKS compute cluster, plus a CI/CD pipeline skeleton using GitHub Actions.

**What this repo contains**

- Terraform skeleton that demonstrates a production-oriented VPC + subnet layout and a placeholder EKS cluster resource.
- An example workflow and README with commands, diagram and hardening notes.

## Architecture Topology

```mermaid
graph TD
    A[Local Code Mutation] -->|Git Push Event| B[GitHub Actions Runner Engine]
    B -->|Step 1: Quality Audit| C{Terraform Init & Validate}
    C -->|Pass| D[Multi-stage Container Build & Cache]
    D -->|Step 2: Plan| E[Terraform Plan (Dry Run)]
    E -->|Step 3: Apply| F[Terraform Apply → AWS (VPC, Subnets, EKS)]

    style B fill:#1e1e2f,stroke:#22c55e,stroke-width:2px
    style F fill:#0f172a,stroke:#3b82f6,stroke-width:2px
```

## System Stack & Core Dependencies

- Infrastructure: Terraform (recommended >= 1.5, tested with 1.7)
- Cloud: Amazon Web Services (AWS)
- CI: GitHub Actions

## Repository layout

```
iac-deployment-pipeline/
├── .github/
│   └── workflows/
│       └── deploy.yml       # CI skeleton (workflow example)
├── terraform/
│   └── main.tf              # Example VPC, subnets and EKS placeholder
└── README.md
```

## Quick Audit Notes (Terraform)

- `terraform/main.tf` is a minimal, illustrative example — it will NOT create a functional EKS cluster as-is.
  - Missing required IAM resources: `aws_iam_role` for EKS control plane, IAM policies, and node instance roles.
  - Missing networking resources commonly required for a public/private VPC: Internet Gateway, Route Table(s), and Route Table associations for public subnets.
  - No security groups, no EKS addon or nodegroup configuration.
  - Contains a hard-coded placeholder `role_arn` value (example `arn:aws:iam::123456789012:role/MockEKSRuntimeRole`). Replace with a variable or real IAM role.

Recommendations:

- Split the configuration into modules (vpc, networking, eks, iam, outputs) for reuse and testability.
- Add `variables.tf`, `outputs.tf`, and a `providers.tf` with backend configuration for a remote state (S3 + DynamoDB lock) in non-local environments.
- Add `terraform.tfvars` (sample) and sensible defaults for `region`, `cluster_name`, and `role_arn`.

## Portfolio mode — safe by default

This repository is configured for portfolio/demo use. All automation scripts that would create cloud or GitHub resources are intentionally safe-by-default and will only display the commands to run unless you pass `--execute`.

- Scripts that are safe-by-default:
  - `terraform/deploy-backend-stack.sh` — preview CloudFormation deploy; add `--execute` to actually deploy.
  - `terraform/create-backend.sh` — preview AWS CLI calls to create S3/DynamoDB; add `--execute` to run.
  - `.github/create-environment.sh` — preview GitHub API calls; add `--execute` to run.

Be careful: running with `--execute` will create real cloud or GitHub resources. For a portfolio, you can keep the scripts as-is and they will not touch your accounts.

## Local Setup / Usage

1. Install required CLIs:

```bash
terraform --version
git --version
```

2. Work locally (recommended first-run):

```bash
cd terraform
terraform init
terraform validate
terraform plan
```

Notes:

- The example `main.tf` is intentionally compact. Before `terraform apply` you must:
  - Provide a valid `role_arn` for EKS control plane via a variable or create the IAM role in Terraform (recommended).
  - Add required networking pieces (Internet Gateway / Route Tables) if you expect the cluster to reach the internet.
  - Configure a remote state backend for team use (S3 + DynamoDB lock recommended).

## Example improvements to implement next

- Add `variables.tf` and `outputs.tf`.
- Add an `iam.tf` that creates the EKS role with the correct assume-role policy.
- Add `node_groups` via `aws_eks_node_group` or use `aws_eks_fargate_profile` depending on workload.
- Harden networking: create NAT Gateways for private subnets (cost/availability trade-offs) and explicit route tables.
- Add GitHub Actions workflow that runs `terraform fmt`, `terraform init -backend=false`, `terraform validate`, and `terraform plan` and stores the plan as an artifact.

## CI/CD pipeline notes

- The provided workflow skeleton is a good starting point for quick validation. For production pipelines:
  - Use the official `hashicorp/setup-terraform` action to pin versions.
  - Cache plugin and module downloads if your CI runners are ephemeral.
  - Store sensitive credentials (AWS keys) in GitHub Secrets and use short-lived OIDC tokens and workload identity where possible.

---

If you want, I can:

- create `variables.tf` and `outputs.tf` templates,
- add a minimal `iam.tf` to provision a correct EKS control-plane role, or
- scaffold a production-ready workflow with remote state configuration.

Files audited: [terraform/main.tf](terraform/main.tf) — updated: [README.md](README.md)
