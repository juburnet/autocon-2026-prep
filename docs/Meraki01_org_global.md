# Step 2 - `data/1_org_global.nac.yaml`: org and global settings

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

!!! tip "Why `data/` only has one file so far"
    `meraki/data/` - the directory Terraform actually reads - starts with
    just `1_org_global.nac.yaml` in place. Every later step's file lives in
    `meraki/data-lab-task/` until it's that step's turn: you **move** (not
    copy) each file into `data/` as you reach it, which is what actually adds
    it to the merged model. `data-lab-task/` itself is never read by
    Terraform - it's a staging shelf, not a second source of truth.

## Validating before you deploy

Network as Code validation happens in two layers that catch different kinds
of mistakes, both running before anything touches the Dashboard:

- **Syntax (schema) validation** checks that your YAML is well-formed and
  that every value matches the schema's expected type, format, and range -
  wrong types, out-of-range numbers, missing required fields. It has no
  opinion on whether a value makes business sense, only whether it's a legal
  value for that field. This is what the `validate` stage of this repo's
  GitLab pipeline (`.gitlab-ci.yml`) runs on every push.
- **Semantic (business-rule) validation** goes further: custom logic runs
  against the parsed configuration to enforce policies a schema can't
  express on its own - e.g. "the administrator must never be named `root`".
  A file can pass every syntax check and still fail here.

### Try it: a syntax failure

`login_security.num_different_passwords` in this file is `5`. `meraki/.schema.yaml` declares that field as `int(min=5, required=False)` - `5` is
the lowest legal value. Temporarily lower it to `3` and regenerate + check
the merged model, exactly like the CI `validate` stage does:

The `terraform apply` below is limited by `-target` to the one resource that
writes the merged model file to disk. It does **not** contact the Dashboard or
change any configuration.

```sh
cd meraki
terraform apply -auto-approve -input=false -target='module.meraki.module.model.local_sensitive_file.model[0]'
nac-validate ./meraki_merged_configuration.nac.yaml
```

You should see an error citing `num_different_passwords` below the schema's
`min=5` - a syntax-level violation, caught before anything else runs. Set it
back to `5` when you're done.

### Try it: a semantic failure

`meraki/rules/101_admin_name.py` is a custom rule: it rejects any
administrator named `root`. Temporarily change `administrator.name` above
from `admin` to `root`, then run the business-rule check (a separate tool
from the schema check above; see `meraki/README.md`):

```sh
pip install nac-validate
nac-validate -r rules data/*.nac.yaml
```

This fails with a `HIGH` severity violation on rule `101` - the YAML is
perfectly legal syntax, but it breaks a policy the schema can't express.
Change `administrator.name` back to `admin` when you're done.

---

**← Previous:** [Log in and identify your lab organization](Meraki00_login.md) · **Next:** [Networks and the MX appliance](Meraki02_networks.md)
