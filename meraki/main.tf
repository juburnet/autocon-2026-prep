terraform {
  # backend "http" {
  #   skip_cert_verification = true
  # }
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
  source           = "github.com/netascode/terraform-meraki-nac-meraki"
  yaml_directories = ["data"]
  write_model_file = "meraki_merged_configuration.nac.yaml"
}

