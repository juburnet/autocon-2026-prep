# Step 3 - `data/3_switching.nac.yaml`: the MS switch

Adds the switch device per branch with per-port-range overrides: an uplink
trunk port, infra ports disabled by default, an AP trunk port, and end-user
access ports carrying VLAN 10 data with VLAN 20 as the voice VLAN. Also sets
switch-wide settings (management VLAN 999, MTU, QoS trust rules per VLAN,
storm control) and the wired 802.1X access policy.

**Key idea:** this step depends conceptually on step 2's VLANs (it references
VLAN IDs 10/20/30/40/50/999 defined there), but there is no explicit
dependency in the YAML - Terraform's resource graph handles that at apply
time, regardless of which file either block lives in.

---

**← Previous:** [Networks and the MX appliance](Meraki02_networks.md) · **Next:** [Wireless](Meraki04_wireless.md)
