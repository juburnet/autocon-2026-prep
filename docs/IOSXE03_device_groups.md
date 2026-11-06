# Step 3 - `data/3_device_groups.nac.yaml`: device groups

Device groups apply shared configuration to a *role*, without repeating it
per device. This step introduces two groups:

```yaml
---
iosxe:
  device_groups:
    - name: LEAVES
      devices: [Leaf1, Leaf2, Leaf3, Leaf4]
      configuration:
        access_lists:
          standard:
            - name: FabricUplinkACL
              entries:
                - sequence: 10
                  action: permit
                  prefix: 10.255.0.0
                  prefix_mask: 0.0.255.255
    - name: BORDER_SPINES
      devices: [Border-Spine1, Border-Spine2]
      configuration:
        access_lists:
          standard:
            - name: FabricUplinkACL
              entries:
                - sequence: 10
                  action: permit
                  prefix: 10.255.0.0
                  prefix_mask: 0.0.255.255
```

Both groups get the same standard ACL, `FabricUplinkACL`, permitting the
`10.255.0.0/16` fabric range - a stand-in for "the fabric-facing devices
all need this filter," authored once per role instead of six times.

**Key idea:** device groups answer *which devices* get a piece of config; the
devices listed under `devices:` must already exist (defined in step 2) for the
group membership to resolve. This naturally depends on step 2, even though
nothing in the YAML enforces that ordering explicitly - Terraform's own
dependency graph (not file order) decides real apply order.

---

**← Previous:** [Devices and uplinks](IOSXE02_devices.md) · **Next:** [Templates](IOSXE04_templates.md)
