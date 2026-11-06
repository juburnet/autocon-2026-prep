# Step 2 - `data/2_networks.nac.yaml`: networks and the MX appliance

This is the largest file and introduces the two branch networks (`Unified
Branch 1`, `Unified Branch 2`) plus an unmanaged hub network referenced by
`!env vpn_hub_network_name`. For each branch it covers:

- Network basics: `product_types` (appliance/switch/wireless), time zone,
  tags, local status page credentials, SNMP, syslog, NetFlow, and
  `group_policies` that tag client traffic into VLANs (Employees→10,
  Voice→20, Iot→30).
- The MX appliance device itself (claimed by serial, WAN1/WAN2 uplinks).
- Appliance config authored directly as YAML: `appliance.vlans` (Data/Voice/
  Iot/PCI/Guest/Infra, each its own subnet), `appliance.vpn_site_to_site_vpn`
  (spoke config pointing at the hub), `appliance.ports` (trunk vs. disabled
  ranges), and `appliance.traffic_shaping` (bandwidth limits, custom
  performance classes, uplink-selection policies).

**Key idea:** everything here is still "direct YAML" - no templates yet. The
VLANs defined here (10/20/30/40/50/999) are what step 3's switch ports and
step 4's SSIDs reference by ID.

---

**← Previous:** [Org and global settings](Meraki01_org_global.md) · **Next:** [Switching](Meraki03_switching.md)
