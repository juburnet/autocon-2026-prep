# Applying Part 2

```sh
cd ios-xe
terraform init
terraform plan
terraform apply
```

`main.tf` sets `write_model_file = "xe_merged_config.nac.yaml"`, so after a
plan/apply you can inspect the fully-resolved model - confirm `${SITE}` and
`${HOSTNAME}` resolved to literal values with no `${...}` markers remaining,
and that `access_switch_vlans` expanded onto Leaf1-4 only.

---

**← Previous:** [Templates](IOSXE04_templates.md)
