*** Settings ***
Documentation   Verify Banner Configuration
Suite Setup     Run Only Once   Get Configs
Resource        ../iosxe_common.resource
Default Tags    config   iosxe   banner

*** Test Cases ***

{% for device in iosxe.devices | default([]) %}
{% if device.configuration.banner | default(defaults.iosxe.configuration.banner) is defined %}
Verify Banner Device {{ device.name }}
    ${config}=   Get Parallel Value For Key   {{ device.name }}_config
    Should Be Equal Value Xml String   ${config}   data/native/banner/login/banner   {{ device.configuration.banner.login | default(defaults.iosxe.configuration.banner.login) | default() | normalize_string }}
    Should Be Equal Value Xml String   ${config}   data/native/banner/exec/banner   {{ device.configuration.banner.exec | default(defaults.iosxe.configuration.banner.exec) | default() | normalize_string }}
    Should Be Equal Value Xml String   ${config}   data/native/banner/prompt-timeout/banner   {{ device.configuration.banner.prompt_timeout | default(defaults.iosxe.configuration.banner.prompt_timeout) | default() | normalize_string }}
    Should Be Equal Value Xml String   ${config}   data/native/banner/motd/banner   {{ device.configuration.banner.motd | default(defaults.iosxe.configuration.banner.motd) | default() | normalize_string }}
{% endif %}
{% endfor %}