#!/usr/bin/env bash
set -euo pipefail

# Create a GitHub environment and configure protection rules using the GitHub CLI (gh)
# Usage: ./create-environment.sh <environment-name> <required-reviewer-team-slug>

ENV_NAME="$1"
REVIEWER_TEAM="$2"
EXECUTE=false

for arg in "$@"; do
  if [ "$arg" = "--execute" ]; then
    EXECUTE=true
  fi
done

if [ -z "$ENV_NAME" ] || [ -z "$REVIEWER_TEAM" ]; then
  echo "Usage: $0 <environment-name> <required-reviewer-team-slug> [--execute]"
  echo "This script is SAFE by default and will only show the API calls. Add --execute to run them."
  exit 1
fi

echo "Preview: Create environment via gh API for environment: $ENV_NAME"
echo "gh api --method PUT /repos/{owner}/{repo}/environments/$ENV_NAME -f wait_timer=0"
echo "gh api --method POST /repos/{owner}/{repo}/environments/$ENV_NAME/deployment_protection_rules -f required_approving_review_count=1 -f bypass_actors=\"[]\" -F required_approving_review_team_slugs=\"[${REVIEWER_TEAM}]\""

if [ "$EXECUTE" = true ]; then
  echo "Executing GitHub API calls (this WILL create the environment)..."
  gh api --method PUT /repos/{owner}/{repo}/environments/$ENV_NAME -f wait_timer=0
  gh api --method POST /repos/{owner}/{repo}/environments/$ENV_NAME/deployment_protection_rules -f required_approving_review_count=1 -f bypass_actors="[]" -F required_approving_review_team_slugs="[${REVIEWER_TEAM}]"
  echo "Environment $ENV_NAME created. Update the script to replace {owner}/{repo} or run from CI with GH repository context."
else
  echo "Dry-run complete. Add --execute to actually create the environment."
fi
