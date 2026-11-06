# Autocon 2026 - Network-as-Code Lab Guide

This guide walks through both halves of the Autocon 2026 Network-as-Code lab,
in order:

- **Part 1 - Meraki**, five steps authoring a two-branch Meraki network
  (appliance, switch, wireless) directly in YAML, ending on a
  templating/indirection capstone.
- **Part 2 - IOS-XE**, four steps building a simple L3 spine/leaf fabric
  (VLANs + routed point-to-point uplinks), ending on the same
  templating/indirection pattern so the two halves reinforce each other.

Both parts use the same underlying mechanic: a Terraform `nac-*` module reads
every YAML file under a project's `data/` directory, deep-merges them into one
model (matching on `name` at each nesting level), and applies the result.
File names and numeric prefixes are a **reading order**, not a deployment
order - Terraform builds its own dependency graph from the merged model.

---

**Next:** [Part 1 - Meraki: org and global settings](Meraki01_org_global.md){.next-only}
