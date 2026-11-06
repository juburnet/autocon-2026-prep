module "iosxe" {
  source  = "netascode/nac-iosxe/iosxe"

  yaml_directories = ["data"]
  write_model_file = "xe_merged_config.nac.yaml"
  device_transaction = true
}

