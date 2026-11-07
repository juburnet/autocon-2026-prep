terraform {
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

# State: this repo runs locally with no backend block, so Terraform writes
# terraform.tfstate next to this file; in CI it's cached/restored via the
# meraki/.gitlab-ci.yml `cache:` key instead of a remote backend.
#
# If this ever moves to GitLab-managed remote state, add:
#   terraform {
#     backend "http" {}
#   }
# and set these CI/CD variables (see the netascode/nac-iosxe reference
# pipeline for the full set): TF_HTTP_ADDRESS, TF_HTTP_LOCK_ADDRESS,
# TF_HTTP_UNLOCK_ADDRESS, TF_HTTP_LOCK_METHOD, TF_HTTP_UNLOCK_METHOD,
# TF_HTTP_USERNAME, TF_HTTP_PASSWORD, and TF_HTTP_CLIENT_CA_CERTIFICATE_PEM
# (only needed if the GitLab instance uses a private CA).

