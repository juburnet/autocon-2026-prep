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
  write_model_file = "merged_configuration.nac.yaml"
}

