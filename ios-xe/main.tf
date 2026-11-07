terraform {
  backend "http" {}
}

module "iosxe" {
  source  = "netascode/nac-iosxe/iosxe"
  version = "1.0.0"

  yaml_directories   = ["data"]
  write_model_file   = "xe_merged_config.nac.yaml"
  device_transaction = true
}

# State: GitLab-managed remote state via the `http` backend above. The
# backend has no address here on purpose — it's entirely configured via
# TF_HTTP_* environment variables set in ios-xe/.gitlab-ci.yml, so no
# local terraform.tfstate file or GitLab CI `cache:` key is needed.

