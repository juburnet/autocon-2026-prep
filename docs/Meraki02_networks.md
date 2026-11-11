# Step 3 - `data/2_networks.nac.yaml`: networks and the MX appliance

!!! tip "Move this step's file into place"
    Move `data-lab-task/2_networks.nac.yaml` into `data/` before you run
    `terraform plan`/`apply` for this step - that's what adds the branch
    network and MX appliance to the merged model.

This is the largest file and introduces the branch network (named via `!env
branch_name` - unique per attendee pod) plus an unmanaged hub network
referenced by `!env vpn_hub_network_name`. For the branch it covers:

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
VLANs defined here (10/20/30/40/50/999) are what step 4's switch ports and
step 5's SSIDs reference by ID.

## Testing it: run `nac-test` right after this step

You don't have to wait until every step is deployed to check your work. Once
the network exists, `tests/templates/config/networks_list.robot` already has
something to verify: the network's `name`, `product_types`, `time_zone`, and
`tags` against the live Dashboard. Right after this step's `terraform apply`
has finished, regenerate the merged model file and run the tests:

```sh
cd meraki
terraform apply
terraform apply -target=module.meraki.module.model -auto-approve   # only rewrites meraki_merged_configuration.nac.yaml locally
nac-test -d ./meraki_merged_configuration.nac.yaml -t ./tests/templates -o ./tests/results
```

Open `tests/results/report.html` to see the pass/fail result. Running this
now, rather than waiting for the full deployment, is a useful habit: the
sooner post-deploy drift or a misconfiguration is caught, the cheaper it is
to fix.

---

**← Previous:** [Org and global settings](Meraki01_org_global.md) · **Next:** [Switching](Meraki03_switching.md)
