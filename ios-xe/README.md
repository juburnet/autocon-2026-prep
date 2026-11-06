# Autocon 2026 – IOS-XE Network-as-Code Lab

## Overview

This folder configures a 6-device IOS-XE spine/leaf fabric (`Border-Spine1`,
`Border-Spine2`, `Leaf1`-`Leaf4`) using the
[`netascode/nac-iosxe`](https://registry.terraform.io/modules/netascode/nac-iosxe/iosxe/latest)
module, driven entirely by YAML under `data/`. The fabric is a simple **L3
design**: VLANs for access-layer traffic, plus routed, dual-homed
point-to-point uplinks from each leaf to both border-spines (no BGP/EVPN).

The module reads **every** `*.yaml` file in `data/`, deep-merges them into a
single model (matching on `name` at each nesting level), and applies the
result. This means:

- File names and the order files are read in have **no effect** on the
  resulting configuration or on Terraform's actual apply order — Terraform
  builds its own resource dependency graph from the merged model.
- The `1_`, `2_`, `3_`... prefixes on the files in `data/` are purely a
  **reading / teaching order** — a suggested path from "global settings and
  per-device identity/uplinks" to "the templating/indirection pattern" at the
  end, not a staged deployment mechanism. The two `4_` files share a prefix on
  purpose: the template library and the device group that applies it are a
  matched pair and are always read (and deployed) together.

The `netascode/nac-iosxe` provider (`CiscoDevNet/iosxe`) talks to devices over
**NETCONF only** (no RESTCONF) — each device must have `netconf-yang` enabled.

## Deployment order

| File | Introduces |
|---|---|
| `data/1_global.nac.yaml` | Global settings shared by every device: the `${SITE}` variable, a login banner that references both `${SITE}` and the per-device `${HOSTNAME}` variable, and `system.hostname` set from `${HOSTNAME}`. |
| `data/devices/*.nac.yaml` | Per-device registration (`name`, `host`), the `HOSTNAME` variable that resolves the global banner/hostname for that device, a `Loopback0` device-identity interface (`10.255.0.0/16` range), and the device's routed fabric uplink interface(s) per the cabling/IP plan below. |
| `data/3_device_groups.nac.yaml` | Two device groups, `LEAVES` (Leaf1-4) and `BORDER_SPINES` (Border-Spine1-2), each carrying a shared standard ACL (`FabricUplinkACL`) permitting the `10.255.0.0/16` fabric range. Depends conceptually on the devices defined in the previous step. |
| `data/4_templates.nac.yaml` + `data/4_templates_assignment.nac.yaml` | Introduces the templating/indirection pattern, as a paired step — deployed together since one is meaningless without the other. `4_templates.nac.yaml` is the template library (`access_switch_vlans`, a `type: model` template defining VLANs 10/DATA, 20/VOICE, 99/MGMT); `4_templates_assignment.nac.yaml` applies that template to the `LEAVES` device group by matching `name: LEAVES`, merging into the group defined in step 3. |

### Fabric cabling and IP plan

Each leaf is dual-homed: one routed uplink to each border-spine. `Gi1/0/1` on
every border-spine is reserved for the external/mgmt-bridge uplink and is not
touched by this lab.

| Leaf | Leaf port | Border-Spine1 port | Border-Spine2 port |
|---|---|---|---|
| Leaf1 | Gi1/0/1 ↔ BS1 Gi1/0/2 | Gi1/0/2 | — |
| Leaf1 | Gi1/0/2 ↔ BS2 Gi1/0/2 | — | Gi1/0/2 |
| Leaf2 | Gi1/0/1 ↔ BS1 Gi1/0/3 | Gi1/0/3 | — |
| Leaf2 | Gi1/0/2 ↔ BS2 Gi1/0/3 | — | Gi1/0/3 |
| Leaf3 | Gi1/0/1 ↔ BS1 Gi1/0/4 | Gi1/0/4 | — |
| Leaf3 | Gi1/0/2 ↔ BS2 Gi1/0/4 | — | Gi1/0/4 |
| Leaf4 | Gi1/0/1 ↔ BS1 Gi1/0/5 | Gi1/0/5 | — |
| Leaf4 | Gi1/0/2 ↔ BS2 Gi1/0/5 | — | Gi1/0/5 |

Fabric addressing uses `10.255.0.0/16`, separate from the existing management
range below: `Loopback0` (`/32`) identifies each device (`10.255.0.1`/`.2` for
the border-spines, `10.255.0.11`-`.14` for Leaf1-4); each leaf's uplink to
Border-Spine1 comes from the `10.255.11.0/24` range and its uplink to
Border-Spine2 from the equivalent `/30` in `10.255.12.0/24`.

## Prerequisites

- Terraform >= 1.9 and the [IOS-XE provider](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest)
  (fetched automatically as a dependency of the `nac-iosxe` module).
- All 6 devices share one set of SSH credentials, set via the provider's
  environment variables:
  - `IOSXE_USERNAME` (e.g. `admin`)
  - `IOSXE_PASSWORD`
  - Optionally `IOSXE_INSECURE=true` to skip SSH host-key verification (useful
    for CML-hosted lab nodes); this is already the provider default.

## Devices

| Hostname | Management IP (Vlan1) |
|---|---|
| Border-Spine1 | 198.18.128.201 |
| Leaf1 | 198.18.128.202 |
| Border-Spine2 | 198.18.128.203 |
| Leaf2 | 198.18.128.204 |
| Leaf3 | 198.18.128.205 |
| Leaf4 | 198.18.128.206 |

All on VLAN1, subnet `198.18.128.0/18`, default route via gateway
`198.18.128.1`, reachable through the CML "System Bridge" external connector.

## Applying the configuration

```sh
terraform init
terraform plan
terraform apply
```

## Testing

- `rules/` holds [`iac-validate`](https://github.com/netascode/iac-validate) semantic
  rules (e.g. `201_unique_device_host.py` blocks two devices sharing the same
  `host`/management IP):

  ```sh
  pip install iac-validate
  iac-validate -r rules data/**/*.nac.yaml
  ```

- `tests/templates/` holds a [`nac-test`](https://github.com/netascode/nac-test)
  Robot Framework suite that connects to each live device over NETCONF and checks
  it against the YAML model (`devices/hostname.robot` verifies the device's
  configured hostname matches `devices[].variables.HOSTNAME`). The NETCONF
  transport (`tests/templates/iosxe_netconf.py`) uses the `ncclient` package,
  which isn't one of `nac-test`'s own dependencies and needs installing
  separately:

  ```sh
  pip install ncclient
  ```

  It authenticates with the same `IOSXE_USERNAME` / `IOSXE_PASSWORD` /
  `IOSXE_INSECURE` env vars as the Terraform provider (see Prerequisites above).
  Needs the merged model written to disk first:

  ```sh
  terraform apply -target=module.iosxe.module.model -auto-approve
  nac-test -d ./xe_merged_config.nac.yaml -t ./tests/templates -o ./tests/results
  ```
