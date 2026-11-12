# Step 2 - `data/devices/*.nac.yaml`: device identity

Each of the 4 devices gets its own file (unchanged from the original stubs,
which only had `name`/`host`). Each now adds:

- `variables.HOSTNAME` - resolves the `${HOSTNAME}` references from step 1
  for that device.

Example (`data/devices/Access1.nac.yaml`):

```yaml
---
iosxe:
  devices:
    - name: Access1
      host: 198.18.128.204
      variables:
        HOSTNAME: Access1
```

**Key idea:** this is still 100% direct, per-device YAML - no groups, no
templates. Every device's configuration is fully visible in its own file.

---

**← Previous:** [Global config](IOSXE01_global.md) · **Next:** [Device groups](IOSXE03_device_groups.md)
