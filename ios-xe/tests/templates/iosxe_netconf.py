# iosxe_netconf.py
#
# Minimal NETCONF helper for Robot tests, mirroring the role meraki_request.py
# plays for the Meraki test suite: own the transport/credential handling so
# the .robot files stay declarative. Credentials come from the same
# IOSXE_USERNAME / IOSXE_PASSWORD / IOSXE_INSECURE env vars the Terraform
# provider uses (see ios-xe/README.md Prerequisites).
#
# Requires the `ncclient` package (not part of mkdocs' requirements.txt -
# install separately before running this suite: pip install ncclient).

import os
import re
from ncclient import manager
from robot.api import logger

NETCONF_PORT = 830

HOSTNAME_FILTER = """
<filter>
  <native xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native">
    <hostname/>
  </native>
</filter>
"""


class NetconfCredentialsError(Exception):
    def __init__(self):
        super().__init__("IOSXE_USERNAME and IOSXE_PASSWORD must be set")


def _connect(host):
    username = os.environ.get("IOSXE_USERNAME")
    password = os.environ.get("IOSXE_PASSWORD")
    if not username or not password:
        raise NetconfCredentialsError()

    insecure = os.environ.get("IOSXE_INSECURE", "true").lower() == "true"

    return manager.connect(
        host=host,
        port=NETCONF_PORT,
        username=username,
        password=password,
        hostkey_verify=not insecure,
        device_params={"name": "iosxe"},
        timeout=30,
    )


def get_hostname(host):
    with _connect(host) as m:
        reply = m.get(filter=("subtree", HOSTNAME_FILTER))
        logger.info(f"NETCONF reply from {host}: {reply.data_xml}")

    match = re.search(r"<hostname>([^<]+)</hostname>", reply.data_xml)
    if not match:
        raise Exception(f"hostname element not found in NETCONF reply from {host}")
    return match.group(1)
