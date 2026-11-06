# Part 2 - IOS-XE

Project folder: `ios-xe/`. Module:
[`netascode/nac-iosxe`](https://registry.terraform.io/modules/netascode/nac-iosxe/iosxe/latest).
Prerequisites (provider credentials, devices table) are in `ios-xe/README.md` - this guide focuses on what each step teaches. The underlying concepts
(global → device group → device precedence, variables, `model` templates)
follow the upstream
[`nac-iosxe-learning-lab`](https://netascode.github.io/nac-iosxe-learning-lab/)
Tasks 03/04/06/07 almost verbatim, adapted to this lab's actual 6-device
spine/leaf fabric.

The fabric itself is intentionally simple: **L3 only** - VLANs for
access-layer traffic, plus routed, dual-homed point-to-point uplinks from
each leaf to both border-spines. No BGP/EVPN. Each leaf is dual-homed: one
uplink to Border-Spine1, one to Border-Spine2.

| Leaf | Leaf port | Border-Spine1 port | Border-Spine2 port |
|---|---|---|---|
| Leaf1 | Gi1/0/1 ↔ BS1 Gi1/0/2 | Gi1/0/2 | - |
| Leaf1 | Gi1/0/2 ↔ BS2 Gi1/0/2 | - | Gi1/0/2 |
| Leaf2 | Gi1/0/1 ↔ BS1 Gi1/0/3 | Gi1/0/3 | - |
| Leaf2 | Gi1/0/2 ↔ BS2 Gi1/0/3 | - | Gi1/0/3 |
| Leaf3 | Gi1/0/1 ↔ BS1 Gi1/0/4 | Gi1/0/4 | - |
| Leaf3 | Gi1/0/2 ↔ BS2 Gi1/0/4 | - | Gi1/0/4 |
| Leaf4 | Gi1/0/1 ↔ BS1 Gi1/0/5 | Gi1/0/5 | - |
| Leaf4 | Gi1/0/2 ↔ BS2 Gi1/0/5 | - | Gi1/0/5 |

Fabric addressing lives in `10.255.0.0/16`, separate from the existing
`198.18.128.0/18` management range: `Loopback0` (`/32`) identifies each
device, uplinks to Border-Spine1 come from `10.255.11.0/24` (`/30` per leaf),
uplinks to Border-Spine2 from the equivalent `/30` in `10.255.12.0/24`.

## Step 1 - `data/1_global.nac.yaml`: global configuration and variables

Global configuration applies to **every** registered device unless overridden
at the device-group or device level - the precedence hierarchy is device >
device group > global. This file defines two things:

- A **global variable**, `${SITE}`, set once and inherited by all 6 devices.
- A login banner and `system.hostname` that both reference `${HOSTNAME}` - a
  variable that doesn't exist yet at this level. It's defined **per device**
  in step 2, so the same global template resolves to a different literal
  hostname on each device.

```yaml
---
iosxe:
  global:
    variables:
      SITE: "Autocon 2026 IOS XE Lab"
    configuration:
      banner:
        login: |-
          #########################################
          #   Welcome to the Autocon IOS XE Lab!  #
          #########################################
          Site:   ${SITE}
          Device: ${HOSTNAME}
      system:
        hostname: ${HOSTNAME}
```

**Key idea:** variables let you write one banner template instead of six -
one place to define the hostname per device, used in multiple configuration
sections (banner text *and* the `hostname` CLI command).

---

**← Previous:** [Applying Part 1](Meraki06_applying.md) · **Next:** [Devices and uplinks](IOSXE02_devices.md)
