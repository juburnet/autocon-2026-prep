*** Settings ***
Documentation   Verify VLAN Configuration
Suite Setup     Run Only Once   Get Configs
Resource        ../iosxe_common.resource
Default Tags    config   iosxe   vlan

*** Test Cases ***

{% for device in iosxe.devices | default([]) %}
{% if device.configuration.vlan is defined %}
Get Config {{ device.name }}
    ${config}=   Get Parallel Value For Key   {{ device.name }}_config
    Set Suite Variable   ${config}

{% for vlan in device.configuration.vlan.vlans | default([]) %}
Verify VLAN {{ vlan.id }} Device {{ device.name }}
    ${vlan_xpath}=   Set Variable   data/native/vlan/vlan-list[id='{{ vlan.id }}']
    Should Be Equal Value Xml Numeric   ${config}   ${vlan_xpath}/id   {{ vlan.id }}
    Should Be Equal Value Xml String   ${config}   ${vlan_xpath}/name   {{ vlan.name | default(defaults.iosxe.configuration.vlan.vlans.name) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${vlan_xpath}/shutdown   {{ vlan.shutdown | default(defaults.iosxe.configuration.vlan.vlans.shutdown) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${vlan_xpath}/remote-span   {{ vlan.remote_span | default(defaults.iosxe.configuration.vlan.vlans.remote_span) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${vlan_xpath}/private-vlan/primary   {{ vlan.private_vlan_primary | default(defaults.iosxe.configuration.vlan.vlans.private_vlan_primary) | default() }}
    Should Be Equal Value Xml String   ${config}   ${vlan_xpath}/private-vlan/association   {{ vlan.private_vlan_association | default(defaults.iosxe.configuration.vlan.vlans.private_vlan_association) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${vlan_xpath}/private-vlan/community   {{ vlan.private_vlan_community | default(defaults.iosxe.configuration.vlan.vlans.private_vlan_community) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${vlan_xpath}/private-vlan/isolated   {{ vlan.private_vlan_isolated | default(defaults.iosxe.configuration.vlan.vlans.private_vlan_isolated) | default() }}

{% if vlan.vni is defined or vlan.access_vfi is defined or vlan.evpn_instance is defined or vlan.evpn_instance_vni is defined or vlan.evpn_instance_protected is defined or vlan.evpn_instance_profile is defined or vlan.evpn_instance_profile_protected is defined %}
Verify VLAN Configuration {{ vlan.id }} Device {{ device.name }}
    ${vlanconfig_xpath}=   Set Variable   data/native/vlan/configuration-entry[vlan-id='{{ vlan.id }}']
    Should Be Equal Value Xml Numeric   ${config}   ${vlanconfig_xpath}/vlan-id   {{ vlan.id }}
    Should Be Equal Value Xml Numeric   ${config}   ${vlanconfig_xpath}/member/vni   {{ vlan.vni | default(defaults.iosxe.configuration.vlan.vlans.vni) | default() }}
    Should Be Equal Value Xml String   ${config}   ${vlanconfig_xpath}/member/access-vfi   {{ vlan.access_vfi | default(defaults.iosxe.configuration.vlan.vlans.access_vfi) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${vlanconfig_xpath}/member/evi-member/evpn-instance/manual-evi-config/evi   {{ vlan.evpn_instance | default(defaults.iosxe.configuration.vlan.vlans.evpn_instance) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${vlanconfig_xpath}/member/evi-member/evpn-instance/manual-evi-config/vni   {{ vlan.evpn_instance_vni | default(defaults.iosxe.configuration.vlan.vlans.evpn_instance_vni) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${vlanconfig_xpath}/member/evi-member/evpn-instance/manual-evi-config/protected   {{ vlan.evpn_instance_protected | default(defaults.iosxe.configuration.vlan.vlans.evpn_instance_protected) | default() }}
    Should Be Equal Value Xml String   ${config}   ${vlanconfig_xpath}/member/evi-member/evpn-instance/auto-evi-config/profile   {{ vlan.evpn_instance_profile | default(defaults.iosxe.configuration.vlan.vlans.evpn_instance_profile) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${vlanconfig_xpath}/member/evi-member/evpn-instance/auto-evi-config/protected   {{ vlan.evpn_instance_profile_protected | default(defaults.iosxe.configuration.vlan.vlans.evpn_instance_profile_protected) | default() }}
{% endif %}
{% endfor %}

{% for amap in device.configuration.vlan.access_maps | default([]) %}
Verify VLAN Access Map {{ amap.name }} Sequence {{ amap.sequence }} Device {{ device.name }}
    ${amap_xpath}=   Set Variable   data/native/vlan/access-map[name='{{ amap.name }}'][value='{{ amap.sequence }}']
    Should Be Equal Value Xml String   ${config}   ${amap_xpath}/name   {{ amap.name }}
    Should Be Equal Value Xml Numeric   ${config}   ${amap_xpath}/value   {{ amap.sequence | default(defaults.iosxe.configuration.vlan.access_maps.sequence) | default() }}
    Should Be Equal Value Xml String   ${config}   ${amap_xpath}/action   {{ amap.action | default(defaults.iosxe.configuration.vlan.access_maps.action) | default() }}
    Should Be Equal Value Xml List   ${config}   ${amap_xpath}/match/ip/address   {{ amap.match_ipv4_addresses | default(defaults.iosxe.configuration.vlan.access_maps.match_ipv4_addresses) | default() }}
    Should Be Equal Value Xml List   ${config}   ${amap_xpath}/match/ipv6/address   {{ amap.match_ipv6_addresses | default(defaults.iosxe.configuration.vlan.access_maps.match_ipv6_addresses) | default() }}
{% endfor %}

{% for filter in device.configuration.vlan.filters | default([]) %}
Verify VLAN Filter {{ filter.name }} Device {{ device.name }}
    ${filter_xpath}=   Set Variable   data/native/vlan/filter[word='{{ filter.name }}']
    Should Be Equal Value Xml String   ${config}   ${filter_xpath}/word   {{ filter.name }}
    Should Be Equal Value Xml String   ${config}   ${filter_xpath}/vlan-lists   {{ filter.vlan_lists | default(defaults.iosxe.configuration.vlan.filters.vlan_lists) | default() }}
{% endfor %}

{% for group in device.configuration.vlan.groups | default([]) %}
Verify VLAN Group {{ group.name }} Device {{ device.name }}
    ${group_xpath}=   Set Variable   data/native/vlan/group[name='{{ group.name }}']
    Should Be Equal Value Xml String   ${config}   ${group_xpath}/name   {{ group.name }}
    Should Be Equal Value Xml String   ${config}   ${group_xpath}/vlan-lists   {{ group.vlan_lists | default(defaults.iosxe.configuration.vlan.groups.vlan_lists) | default() }}
{% endfor %}
{% endif %}
{% endfor %}


