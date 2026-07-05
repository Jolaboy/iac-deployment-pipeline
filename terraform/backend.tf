/*
Remote state backend example (S3 + DynamoDB lock).
DO NOT enable this until you have created the S3 bucket and DynamoDB table in your AWS account.
To enable, replace the bucket/table names and uncomment the block below.

terraform {
  backend "s3" {
    bucket         = "REPLACE_ME_TERRAFORM_STATE_BUCKET"
    key            = "iac-deployment-pipeline/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "REPLACE_ME_TF_LOCK_TABLE"
    encrypt        = true
  }
}
*/

# NOTE: The backend block above is intentionally commented out to avoid accidental
# attempts to use your AWS account. Create the S3 bucket and DynamoDB table, then
# uncomment and run `terraform init` to initialize remote state.
