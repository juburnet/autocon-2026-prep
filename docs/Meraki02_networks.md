# Step 3 - `data/2_networks.nac.yaml`: networks and the MX appliance

## Move this step's file into place

Move (don't copy) this step's file into `data/`, the same way you did for
step 1 - `data-lab-task/` is never read by Terraform:

```sh
cd meraki
mv data-lab-task/2_networks.nac.yaml data/
```

Only once it's in `data/` will `terraform plan` show the branch network and
MX appliance being created.

## Open and review the file

This is the largest file in the lab. It introduces the branch network (named
via `!env branch_name` - unique per attendee pod) plus a reference to the
shared hub network via `!env vpn_hub_network_name`. The hub already exists
for the whole pod, so this file only points at it by name - it doesn't
configure it.

For the branch network, `data/2_networks.nac.yaml` configures:

### Where this fits in the data model

Network as Code organizes Meraki configuration into a handful of canonical
elements: organization, network, device, network settings/profiles,
templates, and the three product-specific blocks - appliance, switch,
wireless. This single file already touches four of them - network settings,
one device, and appliance configuration - which is why it's the largest file
in the lab. Templates (the fifth element) don't appear until step 7.

### Network-level settings

- `product_types`: `appliance`, `switch`, `wireless` - this network will
  eventually host all three product families, even though only the MX exists
  so far.
- `settings`: enables the local status page with its own login
  (`local_page_username`/`local_page_password`, both via `!env`), and
  `named_vlans: true` so appliance VLANs can be referenced by name later.
- `snmp`: an SNMPv3 user and passphrase pulled from `!env`, the same pattern
  used for org-level SNMP in the previous step.
- `syslog_servers` and `netflow`: Switch/Air Marshal/Flows/URL/Wireless/
  Appliance event logs go to `3.4.5.6:514`; NetFlow records go to
  `4.5.6.7:2055`.
- `group_policies`: three named policies - `Employees`, `Voice`, `Iot`. A
  group policy is a different schema element from a VLAN - it's a reusable
  bandwidth/firewall/content-filtering override applied to matched clients,
  not an L3 subnet definition. Here each policy's only job is
  `vlan_tagging`, stamping matched clients into VLAN 10, 20, or 30
  respectively - the policy and the VLAN it tags into are two separate
  objects working together.

### The MX appliance device

One `devices` entry claims the MX by serial (`!env branch_mx_serial`), places
it on the map (`lat`/`lng`/`address`), and configures
`appliance.uplinks_settings` for WAN1 and WAN2 - both enabled, untagged, with
dynamic (DHCP) IPv4 addressing.

### Appliance configuration

Everything under the network's own `appliance:` key is still authored
directly as YAML - no templates yet:

- `vlans`: six VLANs - Data (10), Voice (20), Iot (30), PCI (40), Guest (50),
  and Infra (999) - each with its own `/24` subnet, appliance IP, and DHCP
  server settings.
- `vpn_site_to_site_vpn`: this network as an Auto VPN **spoke**, pointed at
  `!env vpn_hub_network_name` as its hub, with a per-subnet `use_vpn` flag -
  every subnet rides the VPN except Guest (50), which stays local.
- `ports`: ports 5-6 and 13-14 trunked with VLANs 1,10,20,30,40,50,999
  allowed; ports 7-12 disabled.
- `traffic_shaping`: global bandwidth limits, two custom performance classes
  (`SaaS_Traffic`, `Critical_Apps`), two shaping rules, per-uplink bandwidth
  limits for WAN1/WAN2/cellular, and three `uplink_selection` policies that
  steer VoIP traffic and one specific TCP/443 destination onto WAN2 while
  everything else prefers WAN1.

## What this step configures, at a glance

```text
data/2_networks.nac.yaml
└── networks
    ├── <branch_name>                        (the branch network)
    │   ├── settings, snmp, syslog_servers, netflow
    │   ├── group_policies
    │   │   ├── Employees → VLAN 10
    │   │   ├── Voice     → VLAN 20
    │   │   └── Iot       → VLAN 30
    │   ├── devices
    │   │   └── MX appliance (branch_mx_serial)
    │   │       └── uplinks_settings: WAN1 + WAN2 (DHCP)
    │   └── appliance
    │       ├── vlans: Data(10) · Voice(20) · Iot(30) · PCI(40) · Guest(50) · Infra(999)
    │       ├── vpn_site_to_site_vpn: spoke → <vpn_hub_network_name>
    │       ├── ports: trunk (5-6, 13-14) · disabled (7-12)
    │       └── traffic_shaping: bandwidth limits, performance classes, uplink selection
    └── <vpn_hub_network_name>               (unmanaged - already exists)
```

**Key idea:** everything here is still "direct YAML" - no templates yet. The
VLANs defined here (10/20/30/40/50/999) are what step 4's switch ports and
step 5's SSIDs reference by ID.

## Testing it: run `nac-test` right after this step

You don't have to wait until every step is deployed to check your work. Once
the network exists, `tests/templates/config/networks_list.robot` already has
something to verify: the network's `name`, `product_types`, `time_zone`, and
`tags` against the live Dashboard. The `.robot` extension is a hint at the
tooling underneath - `nac-test` runs test cases on **Robot Framework**,
generated from **Jinja2** templates against your merged data model, which is
why the test files live under `tests/templates` rather than being plain,
static Robot files. Deploy this step, then run the tests - the same
`terraform apply` also refreshes `meraki_merged_configuration.nac.yaml`
on disk, which is the file `nac-test` reads:

```sh
cd meraki
terraform apply -auto-approve
nac-test -d ./meraki_merged_configuration.nac.yaml -t ./tests/templates -o ./tests/results
```

Open `tests/results/report.html` to see the pass/fail result. Running this
now, rather than waiting for the full deployment, is a useful habit: the
sooner post-deploy drift or a misconfiguration is caught, the cheaper it is
to fix.

---

**← Previous:** [Org and global settings](Meraki01_org_global.md) · **Next:** [Switching](Meraki03_switching.md)
