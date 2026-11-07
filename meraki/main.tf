terraform {
  backend "http" {}
  required_providers {
    meraki = {
      source = "CiscoDevNet/meraki"
    }
  }
}

provider "meraki" {
  retry_on_error_codes = [404, 400, 401]
}

module "meraki" {
  source           = "github.com/netascode/terraform-meraki-nac-meraki?ref=v0.9.0"
  yaml_directories = ["data"]
  write_model_file = "meraki_merged_configuration.nac.yaml"
}

# State: GitLab-managed remote state via the `http` backend above. The
# backend has no address here on purpose — it's entirely configured via
# TF_HTTP_* environment variables set in meraki/.gitlab-ci.yml, so no
# local terraform.tfstate file or GitLab CI `cache:` key is needed.

