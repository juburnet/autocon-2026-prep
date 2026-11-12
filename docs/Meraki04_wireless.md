# Step 6 - `data/4_wireless.nac.yaml`: the CW access point and SSIDs

!!! tip "Move this step's file into place"
    Move `data-lab-task/4_wireless.nac.yaml` into `data/` before you run
    `terraform plan`/`apply` for this step - that's what adds the AP device,
    RF profile, and SSIDs to the merged model.

Adds the AP device per branch (claimed with tags/location only - deliberately
*not* wired to an RF profile at the device level, to sidestep a known
apply-ordering issue described in `meraki/README.md`), plus network-level
`wireless.rf_profiles` and two SSIDs: `Data` (802.1X/RADIUS, default VLAN 10)
and `Guest` (open, splash page, default VLAN 50).

**Key idea:** one more "direct YAML" layer - network + device + SSID
configuration - before the guide pivots to the templating pattern.

## Try it: change a non-impacting setting

Both SSIDs define an `unavailability_schedules` block - `Data` and `Guest`
are both scheduled unavailable Sunday and Saturday 00:00-06:00 for
maintenance. Changing the window only affects when the SSID broadcasts, not
any other device's config, so it's another safe field to practice the
plan/apply loop on:

```yaml
unavailability_schedules:
  enabled: true
  ranges:
    - start_day: Sunday
      start_time: 00:00:00
      end_time: 08:00:00   # was 06:00:00
      end_day: Sunday
    - start_day: Saturday
      start_time: 00:00:00
      end_time: 06:00:00
      end_day: Saturday
```

`terraform plan` shows exactly one changed SSID attribute - apply it, confirm
it in **Wireless > SSIDs > Guest > Scheduled availability** in the Dashboard,
then revert.

---

**← Previous:** [Switching](Meraki03_switching.md) · **Next:** [Templates](Meraki05_templates.md)
