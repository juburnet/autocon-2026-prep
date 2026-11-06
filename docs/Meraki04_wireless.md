# Step 4 - `data/4_wireless.nac.yaml`: the CW access point and SSIDs

Adds the AP device per branch (claimed with tags/location only - deliberately
*not* wired to an RF profile at the device level, to sidestep a known
apply-ordering issue described in `meraki/README.md`), plus network-level
`wireless.rf_profiles` and two SSIDs: `Data` (802.1X/RADIUS, default VLAN 10)
and `Guest` (open, splash page, default VLAN 50).

**Key idea:** one more "direct YAML" layer - network + device + SSID
configuration - before the guide pivots to the templating pattern.

---

**← Previous:** [Switching](Meraki03_switching.md) · **Next:** [Templates](Meraki05_templates.md)
