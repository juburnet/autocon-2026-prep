# Applying Part 1

```sh
cd meraki
terraform init
terraform plan
terraform apply
```

See `meraki/README.md` for the staged `-target` apply workaround if you hit
the RF-profile dependency-ordering gotcha on first apply - it happens because
a device's `wireless.radio_settings.rf_profile_name` reference can resolve
before its RF profile exists in state. Instead of erroring clearly, the
module's lookup silently falls back to `null`, which then fails deep inside
`meraki_wireless_radio_settings`. That's why `data/4_wireless.nac.yaml`'s AP
device omits `radio_settings` entirely by default - it sidesteps the issue
rather than fixing the ordering.

---

**← Previous:** [Templates](Meraki05_templates.md) · **Next:** [CI/CD Pipeline](Meraki07_cicd.md)
