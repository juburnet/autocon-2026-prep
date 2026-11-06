# Step 5 - `data/5_appliance_templates.nac.yaml` + `data/5_appliance_variables.nac.yaml`: templates

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
  - name: Unified Branch 1
    templates:
      - app_fw
      - app_content
      - app_intrusion
      - app_mal
```

The nac module matches `name: Unified Branch 1` against the network already
defined in step 2 and deep-merges the four templates' configuration into it.
Change a rule in the template once, and it propagates to every network that
references it - the same reusability/consistency/maintainability trade-off
you'll see again in IOS-XE Part 2, step 4.

---

**← Previous:** [Wireless](Meraki04_wireless.md) · **Next:** [Applying Part 1](Meraki06_applying.md)
