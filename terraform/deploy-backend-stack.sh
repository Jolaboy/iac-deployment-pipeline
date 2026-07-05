#!/usr/bin/env bash
set -euo pipefail

# Deploy the CloudFormation stack that creates the S3 bucket and DynamoDB table
# Usage: ./deploy-backend-stack.sh <stack-name> <bucket-name> <dynamodb-table> [region]

STACK_NAME="$1"
BUCKET_NAME="$2"
TABLE_NAME="$3"
REGION="${4:-eu-west-2}"
EXECUTE=false

# Require explicit --execute flag to avoid accidental resource creation
for arg in "$@"; do
  if [ "$arg" = "--execute" ]; then
    EXECUTE=true
  fi
done

if [ -z "$STACK_NAME" ] || [ -z "$BUCKET_NAME" ] || [ -z "$TABLE_NAME" ]; then
  echo "Usage: $0 <stack-name> <bucket-name> <dynamodb-table> [region] [--execute]"
  echo "This script is SAFE by default and will only show the commands to run. Add --execute to run them."
  exit 1
fi

echo "Preview: CloudFormation deploy command"
echo "aws cloudformation deploy --stack-name \"$STACK_NAME\" --template-file \"$(dirname "$0")/backend-stack.yml\" --region \"$REGION\" --capabilities CAPABILITY_NAMED_IAM --parameter-overrides StateBucketName=\"$BUCKET_NAME\" LockTableName=\"$TABLE_NAME\" Region=\"$REGION\""

if [ "$EXECUTE" = true ]; then
  echo "Executing CloudFormation deploy (this WILL create resources)..."
  aws cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file "$(dirname "$0")/backend-stack.yml" \
    --region "$REGION" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides StateBucketName="$BUCKET_NAME" LockTableName="$TABLE_NAME" Region="$REGION"

  echo "Stack deployed. Verify outputs with: aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION"
  echo "After stack is created, update terraform/backend.tf with the bucket and table names and run 'terraform init' to enable remote state."
else
  echo "Dry-run complete. Add --execute to actually deploy the CloudFormation stack."
fi
