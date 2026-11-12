# Step 3 - `data/3_device_groups.nac.yaml`: device groups

Device groups apply shared configuration to a *role*, without repeating it
per device. This step introduces one group:

```yaml
---
iosxe:
  device_groups:
    - name: ACCESS_SWITCHES
      devices:
        - Access1
        - Access2
      configuration:
        access_lists:
          standard:
            - name: AccessLayerACL
              entries:
                - sequence: 10
                  action: permit
                  prefix: 198.18.128.0
                  prefix_mask: 0.0.63.255
```

The group gets a standard ACL, `AccessLayerACL`, permitting the lab's
`198.18.128.0/18` management subnet - a stand-in for "the access-layer
devices all need this filter," authored once per role instead of twice.

**Key idea:** device groups answer *which devices* get a piece of config; the
devices listed under `devices:` must already exist (defined in step 2) for the
group membership to resolve. This naturally depends on step 2, even though
nothing in the YAML enforces that ordering explicitly - Terraform's own
dependency graph (not file order) decides real apply order.

---

**← Previous:** [Devices](IOSXE02_devices.md) · **Next:** [Templates](IOSXE04_templates.md)
