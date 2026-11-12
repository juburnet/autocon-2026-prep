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
that `access_switch_vlans` expanded onto Access1 and Access2 only, and that
the `AccessLayerACL` from [device groups](IOSXE03_device_groups.md) appears
under `Access1`/`Access2` but not `Border`/`Core`.

You can verify the same thing directly on the devices over SSH (see
[SSH to devices](IOSXE00_ssh.md)) - connect to `Access1` or `Access2` with
Solar-PuTTY and run:

```text
show access-lists | section AccessLayerACL
```

---

**← Previous:** [Templates](IOSXE04_templates.md)
