# Cheat Sheet

Quick reference for lab access, commands, and YAML syntax used throughout
both parts of the workshop.

## Lab access

| System | Address | Username | Password |
|---|---|---|---|
| Meraki Dashboard | [account.meraki.com/login](https://account.meraki.com/login) | *(provided separately)* | *(provided separately)* |
| GitLab | `TODO-gitlab-url` | dcloud | C1sco12345 |
| Windows Jump Machine | `TODO-jump-host-url` | - | C1sco12345 |

### IOS-XE devices

All 4 devices share one set of NETCONF/SSH credentials.

| Device | IP Address |
|---|---|
| Border | 198.18.128.201 |
| Core | 198.18.128.202 |
| Access1 | 198.18.128.204 |
| Access2 | 198.18.128.205 |

- Username: `nac_admin`
- Password: `cisco`

## Terraform / CLI commands

Run from `meraki/` or `ios-xe/` after sourcing your `.env`:

```sh
source .env
terraform init
terraform plan
terraform apply
```

Other useful commands:

```sh
terraform validate        # check syntax/config without touching devices
terraform fmt -recursive  # format .tf files
terraform state list      # list resources Terraform currently manages
terraform output          # show output values after apply
```

## Environment variables

Set in `.env` (copy from `.env.example`, never commit the real file).

| Variable | Used for |
|---|---|
| `MERAKI_API_KEY` | Meraki Dashboard API auth |
| `org_name` | `!env org_name` - Meraki organization name |
| `branch_name` | `!env branch_name` - your pod's unique network name |
| `branch_mx_serial` / `branch_ms_serial` / `branch_cw_serial` | Appliance/switch/wireless device serials for your pod |
| `vpn_hub_network_name` | Shared hub network referenced by every branch |
| `IOSXE_USERNAME` / `IOSXE_PASSWORD` | Shared SSH credentials for all 4 IOS-XE devices |

See `meraki/README.md` and `ios-xe/README.md` for the complete variable
lists, including the non-secret example credentials (SNMP, RADIUS, local
status page, etc.).

## YAML syntax quick reference

- **`!env VAR_NAME`** - resolves to the value of environment variable
  `VAR_NAME` at apply time. Keeps secrets and pod-specific values (like
  `branch_name`) out of version control while the YAML structure stays
  stable.
- **Merge by `name`** - the `nac-*` Terraform modules read every YAML file
  under `data/`, deep-merging them into one model by matching `name` at each
  nesting level. Two files both containing `name: Unified Branch 1` (or
  `name: !env branch_name`) merge into a single object instead of producing
  two.
- **File naming is reading order, not deployment order** - numeric prefixes
  (`1_`, `2_`, `3_`...) are a suggested teaching path; Terraform builds its
  own dependency graph from the merged model regardless of file name.
- **`${VARIABLE}`** - template-style placeholders (e.g. `${HOSTNAME}`,
  `${SITE}`) resolved from `variables:` blocks defined at the global,
  device-group, or device level, with device-level taking precedence.

---

**← Previous:** [Overview](Intro01_overview.md)
