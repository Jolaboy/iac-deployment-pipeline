#!/usr/bin/env bash
set -euo pipefail

# Creates S3 bucket and DynamoDB table for Terraform remote state locking.
# WARNING: This will call AWS APIs. Do NOT run unless you intend to create resources in your AWS account.
# Requires: AWS CLI configured with appropriate permissions, and region set.

BUCKET_NAME="$1"
DYNAMO_TABLE="$2"
REGION="${3:-eu-west-2}"
EXECUTE=false

for arg in "$@"; do
  if [ "$arg" = "--execute" ]; then
    EXECUTE=true
  fi
done

if [ -z "$BUCKET_NAME" ] || [ -z "$DYNAMO_TABLE" ]; then
  echo "Usage: $0 <bucket-name> <dynamodb-table> [region] [--execute]"
  echo "This script is SAFE by default and will only show the commands to run. Add --execute to run them."
  exit 1
fi

echo "Preview: aws s3api create-bucket --bucket \"$BUCKET_NAME\" --create-bucket-configuration LocationConstraint=$REGION"
echo "Preview: aws s3api put-bucket-encryption --bucket \"$BUCKET_NAME\" --server-side-encryption-configuration '{\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}'"
echo "Preview: aws dynamodb create-table --table-name \"$DYNAMO_TABLE\" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5"

if [ "$EXECUTE" = true ]; then
  echo "Executing AWS API calls (this WILL create resources)..."
  aws s3api create-bucket --bucket "$BUCKET_NAME" --create-bucket-configuration LocationConstraint=$REGION || true
  aws s3api put-bucket-encryption --bucket "$BUCKET_NAME" --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
  aws dynamodb create-table --table-name "$DYNAMO_TABLE" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 || true
  aws dynamodb wait table-exists --table-name "$DYNAMO_TABLE"
  echo "Backend resources created (or already existed). Update backend.tf and run 'terraform init' with backend enabled."
else
  echo "Dry-run complete. Add --execute to actually create the S3 bucket and DynamoDB table."
fi
