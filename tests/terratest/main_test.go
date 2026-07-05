package test

import (
  "testing"

  "github.com/gruntwork-io/terratest/modules/terraform"
)

// Basic Terratest skeleton. This test will run terraform init & plan in the module directory.
// IMPORTANT: Do NOT run this against production or without proper AWS credentials.
func TestTerraformPlan(t *testing.T) {
  t.Parallel()

  terraformOptions := &terraform.Options{
    TerraformDir: "../../terraform",
  }

  // Init & Plan (plan-only; do NOT destroy or apply in tests by default)
  terraform.InitAndPlan(t, terraformOptions)
}
