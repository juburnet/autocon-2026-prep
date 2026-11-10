# Step 6 - `data/5_appliance_templates.nac.yaml` + `data/5_appliance_variables.nac.yaml`: templates

!!! tip "Move this step's files into place"
    Move both `data-lab-task/5_appliance_templates.nac.yaml` and
    `data-lab-task/5_appliance_variables.nac.yaml` into `data/` together -
    they're a matched pair, and the variables file has nothing to reference
    without the template library already in place.

## Why templates

Every step so far wrote full configuration directly under one network -
fine for a single branch, but it doesn't scale once the same policy has to
apply to many branches. If ten branch networks each hardcoded the same
firewall rules, changing one rule means editing it in ten places - and
missing one is how configuration drift starts. A template collapses that:
define the rule set once, as a named, reusable block, then have every
network that needs it reference it by name. One edit to the template
propagates everywhere it's referenced, which is what keeps a fleet of
branches consistent as policy evolves - this lab's single network per pod is
enough to show the mechanic, even though the payoff compounds with scale.

The capstone, and the first point where you stop writing full configuration
per-network and instead write it once, apply it by reference. Deliberately
two files sharing a prefix because they are a matched pair:

- `5_appliance_templates.nac.yaml` is the **template library** - reusable,
  `type: model` appliance firewall-rule templates (`app_fw`, `app_content`,
  `app_intrusion`, `app_mal`), each just a named block of
  `appliance.firewall.*` configuration.
- `5_appliance_variables.nac.yaml` is the **reference** - for each branch
  network, a `templates:` list naming which templates to merge in.

```yaml
# 5_appliance_variables.nac.yaml (excerpt)
networks:
  - name: !env branch_name
    templates:
      - app_fw
      - app_content
      - app_intrusion
      - app_mal
```

The nac module matches `name: !env branch_name` against the network already
defined in step 3 and deep-merges the four templates' configuration into it.
Change a rule in the template once, and it propagates to every network that
references it - the same reusability/consistency/maintainability trade-off
you'll see again in IOS-XE Part 2, step 4.

---

**← Previous:** [Wireless](Meraki04_wireless.md) · **Next:** [Applying Part 1](Meraki06_applying.md)
