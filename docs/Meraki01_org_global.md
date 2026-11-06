# Part 1 - Meraki

Project folder: `meraki/`. Module:
[`terraform-meraki-nac-meraki`](https://github.com/netascode/terraform-meraki-nac-meraki).
Prerequisites and the full environment-variable list are in `meraki/README.md` - this guide focuses on what each step teaches.

## Step 1 - `data/1_org_global.nac.yaml`: org and global settings

The organization level is where settings apply to *everything* below it,
regardless of network or device. This file sets:

- The admin user and a `login_security` policy (password expiration, lockout
  thresholds, idle timeout).
- Org-level SNMPv3 (no v2c), with the auth/priv passphrases pulled from
  environment variables via the `!env` tag rather than hardcoded in YAML.
- An org-wide `appliance.vpn_firewall_rules` rule set - shared-services and
  inter-VLAN-isolation rules every spoke inherits through the VPN hub, so you
  write them once instead of per-branch.

**Key idea:** `!env org_name` and similar tags are how secrets and
environment-specific values stay out of version control while the YAML
structure itself stays stable.

---

**← Previous:** [Overview](Intro01_overview.md) · **Next:** [Networks and the MX appliance](Meraki02_networks.md)
