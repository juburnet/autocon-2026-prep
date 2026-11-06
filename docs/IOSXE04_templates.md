# Step 4 - `data/4_templates.nac.yaml` + `data/4_templates_assignment.nac.yaml`: `model` templates

The capstone, mirroring Meraki's step 5. Templates answer *what
configuration* to apply; device groups (step 3) answer *which devices*. Used
together, you get "this exact VLAN set, on exactly these devices" without
duplicating the VLAN definitions per device. Deliberately split into two
files sharing the `4_` prefix - a template with nothing referencing it does
nothing, so they're always read (and deployed) together, and deliberately
*not* called `4_variables.nac.yaml` to avoid confusion with the unrelated
`${VARIABLE}` substitution feature from steps 1-2.

`4_templates.nac.yaml` - the template library, `type: model` (pure YAML
against the data model, schema-validated - as opposed to `file` or `cli`
template types, not used in this lab):

```yaml
---
iosxe:
  templates:
    - name: access_switch_vlans
      type: model
      configuration:
        vlan:
          vlans:
            - id: 10
              name: DATA
            - id: 20
              name: VOICE
            - id: 99
              name: MGMT
```

`4_templates_assignment.nac.yaml` - the reference, merging into the `LEAVES`
group from step 3 by matching `name: LEAVES`:

```yaml
---
iosxe:
  device_groups:
    - name: LEAVES
      templates:
        - access_switch_vlans
```

After `terraform apply`, VLANs 10/20/99 land on **Leaf1-4 only** - not on the
border-spines, which are never added to this template reference.

**Key idea:** the same deep-merge-by-name mechanic as Meraki's templates
step - NaC reads the template library, finds where it's referenced (here, a
device group instead of a network), and merges the template's configuration
into every member at render time.

---

**← Previous:** [Device groups](IOSXE03_device_groups.md) · **Next:** [Applying Part 2](IOSXE05_applying.md)
