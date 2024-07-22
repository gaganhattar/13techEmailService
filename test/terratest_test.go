package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraform(t *testing.T) {
	awsRegion := os.Getenv("AWS_REGION")
	domainName := "13techs.com"

	terraformOptions := &terraform.Options{
		TerraformDir: "../terraform",

		Vars: map[string]interface{}{
			"aws_region":  awsRegion,
			"domain_name": domainName,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	domain := terraform.Output(t, terraformOptions, "domain")

	assert.Equal(t, domainName, domain)
}
