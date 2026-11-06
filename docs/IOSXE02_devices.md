# Step 2 - `data/devices/*.nac.yaml`: device identity and uplinks

Each of the 6 devices gets its own file (unchanged from the original stubs,
which only had `name`/`host`). Each now adds:

- `variables.HOSTNAME` - resolves the `${HOSTNAME}` references from step 1
  for that device.
- A `Loopback0` interface - a stable, always-up device-identity address
  (`10.255.0.0/16`, `/32`), independent of any physical link state.
- The device's routed fabric uplink interface(s), addressed per the cabling
  table above.

Leaf example (`data/devices/Leaf1.nac.yaml`):

```yaml
---
iosxe:
  devices:
    - name: Leaf1
      host: 198.18.128.202
      variables:
        HOSTNAME: Leaf1
      configuration:
        interfaces:
          loopbacks:
            - id: 0
              description: "Leaf1 device-id loopback"
              ipv4:
                address: 10.255.0.11
                address_mask: 255.255.255.255
          ethernets:
            - id: 1/0/1
              type: GigabitEthernet
              description: "Uplink to Border-Spine1 Gi1/0/2"
              switchport:
                enable: false
              ipv4:
                address: 10.255.11.2
                address_mask: 255.255.255.252
            - id: 1/0/2
              type: GigabitEthernet
              description: "Uplink to Border-Spine2 Gi1/0/2"
              switchport:
                enable: false
              ipv4:
                address: 10.255.12.2
                address_mask: 255.255.255.252
```

Each border-spine mirrors this shape but with **four** downlink interfaces
(`Gi1/0/2`-`Gi1/0/5`, one per leaf) instead of two uplinks - `Gi1/0/1` on
every border-spine is reserved for the external/mgmt-bridge uplink and is
untouched by this lab.

**Key idea:** this is still 100% direct, per-device YAML - no groups, no
templates. Every device's configuration is fully visible in its own file.

---

**← Previous:** [Global config](IOSXE01_global.md) · **Next:** [Device groups](IOSXE03_device_groups.md)
