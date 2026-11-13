class Rule:
    id = "201"
    description = "Each IOS-XE device must have a unique host/management IP"
    severity = "HIGH"
    paths = ["iosxe"]  # ensures this rule is applied to IOS-XE data

    @classmethod
    def match(cls, data, schema=None):
        violations = []

        iosxe_data = data.get("iosxe", {})
        devices = iosxe_data.get("devices", [])

        seen = {}
        for device in devices:
            host = device.get("host")
            name = device.get("name", "unknown device")

            if host is None:
                continue

            if host in seen:
                violations.append(
                    f"Duplicate host '{host}' used by both '{seen[host]}' and '{name}'"
                )
            else:
                seen[host] = name

        return violations
