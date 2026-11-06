# Applying Part 1

```sh
cd meraki
terraform init
terraform plan
terraform apply
```

See `meraki/README.md` for the staged `-target` apply workaround if you hit
the RF-profile dependency-ordering gotcha on first apply.

---

**← Previous:** [Templates](Meraki05_templates.md) · **Next:** [Part 2 - IOS-XE: global config](IOSXE01_global.md)
