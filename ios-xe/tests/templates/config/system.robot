*** Settings ***
Documentation   Verify System Configuration
Suite Setup     Run Only Once   Get Configs
Resource        ../iosxe_common.resource
Default Tags    config   iosxe   system

*** Test Cases ***

{% for device in iosxe.devices | default([]) %}
{% if device.configuration.system is defined %}
Get Config {{ device.name }}
    ${config}=   Get Parallel Value For Key   {{ device.name }}_config
    Set Suite Variable   ${config}

Verify System Device {{ device.name }}
    ${sys_xpath}=   Set Variable   data/native
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/hostname   {{ device.configuration.system.hostname | default(defaults.iosxe.configuration.system.hostname) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/bgp-community/new-format   {{ device.configuration.system.ip_bgp_community_new_format | default(defaults.iosxe.configuration.system.ip_bgp_community_new_format) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ipv6/unicast-routing   {{ device.configuration.system.ipv6_unicast_routing | default(defaults.iosxe.configuration.system.ipv6_unicast_routing) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ipv6/mcr-conf/multicast-routing   {{ device.configuration.system.ipv6_multicast_routing | default(defaults.iosxe.configuration.system.ipv6_multicast_routing) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/source-route   {{ device.configuration.system.ip_source_route | default(defaults.iosxe.configuration.system.ip_source_route) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/domain/lookup   {{ device.configuration.system.ip_domain_lookup | default(defaults.iosxe.configuration.system.ip_domain_lookup) | default() }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/domain/name   {{ device.configuration.system.ip_domain_name | default(defaults.iosxe.configuration.system.ip_domain_name) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/login/delay   {{ device.configuration.system.login_delay | default(defaults.iosxe.configuration.system.login_delay) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/login/on-failure   {{ device.configuration.system.login_on_failure | default(defaults.iosxe.configuration.system.login_on_failure) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/login/on-failure/log   {{ device.configuration.system.login_on_failure_log | default(defaults.iosxe.configuration.system.login_on_failure_log) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/login/on-success   {{ device.configuration.system.login_on_success | default(defaults.iosxe.configuration.system.login_on_success) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/login/on-success/log   {{ device.configuration.system.login_on_success_log | default(defaults.iosxe.configuration.system.login_on_success_log) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/domain/lookup-settings/lookup/nsap   {{ device.configuration.system.ip_domain_lookup_nsap | default(defaults.iosxe.configuration.system.ip_domain_lookup_nsap) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/domain/lookup-settings/lookup/recursive   {{ device.configuration.system.ip_domain_lookup_recursive | default(defaults.iosxe.configuration.system.ip_domain_lookup_recursive) | default() }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/diagnostic/bootup/level   {{ device.configuration.system.diagnostic_bootup_level | default(defaults.iosxe.configuration.system.diagnostic_bootup_level) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/subscriber/templating   {{ device.configuration.system.subscriber_templating | default(defaults.iosxe.configuration.system.subscriber_templating) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/memory/free/low-watermark/processor   {{ device.configuration.system.memory_free_low_watermark_processor | default(defaults.iosxe.configuration.system.memory_free_low_watermark_processor) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/ssh/time-out   {{ device.configuration.system.ssh.time_out | default(defaults.iosxe.configuration.system.ssh.time_out) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/ssh/authentication-retries   {{ device.configuration.system.ssh.authentication_retries | default(defaults.iosxe.configuration.system.ssh.authentication_retries) | default() }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/name-server/no-vrf-ordered   {{ device.configuration.system.ip_name_servers | default(defaults.iosxe.configuration.system.ip_name_servers) | default() }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/call-home/contact-email-addr   {{ device.configuration.system.call_home_contact_email | default(defaults.iosxe.configuration.system.call_home_contact_email) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/call-home/tac-profile/profile/CiscoTAC-1/active   {{ device.configuration.system.call_home_cisco_tac_1_profile_active | default(defaults.iosxe.configuration.system.call_home_cisco_tac_1_profile_active) | default() }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/call-home/tac-profile/profile/CiscoTAC-1/destination/transport-method   {{ device.configuration.system.call_home_cisco_tac_1_destination_transport_method | default(defaults.iosxe.configuration.system.call_home_cisco_tac_1_destination_transport_method) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/tcp/path-mtu-discovery   {{ device.configuration.system.ip_tcp_path_mtu_discovery | default(defaults.iosxe.configuration.system.ip_tcp_path_mtu_discovery) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/tcp/mss   {{ device.configuration.system.ip_tcp_mss | default(defaults.iosxe.configuration.system.ip_tcp_mss) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/tcp/window-size   {{ device.configuration.system.ip_tcp_window_size | default(defaults.iosxe.configuration.system.ip_tcp_window_size) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/nbar/classification/dns/classify-by-domain-with-default   {{ device.configuration.system.ip_nbar_classification_dns_classify_by_domain | default(defaults.iosxe.configuration.system.ip_nbar_classification_dns_classify_by_domain) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/multicast/route-limit-container/routelimit   {{ device.configuration.system.ip_multicast_route_limit | default(defaults.iosxe.configuration.system.ip_multicast_route_limit) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/igmp/snooping-entry/snooping/querier-conf/querier   {{ device.configuration.system.igmp_snooping_querier | default(defaults.iosxe.configuration.system.igmp_snooping_querier) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/igmp/snooping-entry/snooping/querier-entry/version   {{ device.configuration.system.igmp_snooping_querier_version | default(defaults.iosxe.configuration.system.igmp_snooping_querier_version) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/igmp/snooping-entry/snooping/querier-entry/max-response-time   {{ device.configuration.system.igmp_snooping_querier_max_response_time | default(defaults.iosxe.configuration.system.igmp_snooping_querier_max_response_time) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/igmp/snooping-entry/snooping/querier-entry/timer/expiry   {{ device.configuration.system.igmp_snooping_querier_timer_expiry | default(defaults.iosxe.configuration.system.igmp_snooping_querier_timer_expiry) | default() }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/domain/list/vrf/domain-name   {{ device.configuration.system.ip_domain_list_vrf_domain | default(defaults.iosxe.configuration.system.ip_domain_list_vrf_domain) | default() }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/domain/list/vrf/vrf-name   {{ device.configuration.system.ip_domain_list_vrf | default(defaults.iosxe.configuration.system.ip_domain_list_vrf) | default() }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/port-channel/load-balance/load-balance   {{ device.configuration.system.port_channel_load_balance | default(defaults.iosxe.configuration.system.port_channel_load_balance) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ipv6/mld/snooping-conf/snooping   {{ device.configuration.system.ipv6_mld_snooping | default(defaults.iosxe.configuration.system.ipv6_mld_snooping) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ipv6/mld/snooping-container/snooping/querier-conf/querier   {{ device.configuration.system.ipv6_mld_snooping_querier | default(defaults.iosxe.configuration.system.ipv6_mld_snooping_querier) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/mac/address-table/aging-time/val   {{ device.configuration.system.mac_address_table_aging_time | default(defaults.iosxe.configuration.system.mac_address_table_aging_time) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/cef-v2/load-sharing-v2/algorithm-v2/include-ports-v2/source   {{ device.configuration.system.cef_ipv4_include_ports_source | default(defaults.iosxe.configuration.system.cef_ipv4_include_ports_source) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/cef-v2/load-sharing-v2/algorithm-v2/include-ports-v2/destination   {{ device.configuration.system.cef_ipv4_include_ports_destination | default(defaults.iosxe.configuration.system.cef_ipv4_include_ports_destination) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ipv6/cef-v2/load-sharing-v2/algorithm-v2/include-ports-v2/source   {{ device.configuration.system.cef_ipv6_include_ports_source | default(defaults.iosxe.configuration.system.cef_ipv6_include_ports_source) | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ipv6/cef-v2/load-sharing-v2/algorithm-v2/include-ports-v2/destination   {{ device.configuration.system.cef_ipv6_include_ports_destination | default(defaults.iosxe.configuration.system.cef_ipv6_include_ports_destination) | default() }}
{% for vrf in device.configuration.system.ip_name_servers_vrf | default([]) %}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/name-server/vrf[word='{{ vrf.vrf }}']/word   {{ vrf.vrf }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/name-server/vrf[word='{{ vrf.vrf }}']/server-ip-list-ordered   {{ vrf.servers | default(defaults.iosxe.configuration.system.ip_name_servers_vrf.servers) | default() }}
{% endfor %}
{% for ip_host in device.configuration.system.ip_hosts | default([]) %}
{% if ip_host.vrf is not defined %}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/host/host-list[name='{{ ip_host.name }}']/name   {{ ip_host.name }}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/host/host-list[name='{{ ip_host.name }}']/ip-list-ordered   {{ ip_host.ips | default(defaults.iosxe.configuration.system.ip_hosts.ips) | default() }}
{% endif %}
{% endfor %}
{% for ip_lookup_vrf in device.configuration.system.ip_domain_lookup_vrfs | default([]) %}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/domain/lookup-settings/lookup/vrf[vrf-name='{{ ip_lookup_vrf.vrf }}']/vrf-name   {{ ip_lookup_vrf.vrf }}
{% if ip_lookup_vrf.source_interface_type | default('') == 'GigabitEthernet' %}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/domain/lookup-settings/lookup/vrf[vrf-name='{{ ip_lookup_vrf.vrf }}']/source-interface/GigabitEthernet   {{ ip_lookup_vrf.source_interface_id | default(defaults.iosxe.configuration.system.ip_domain_lookup_vrfs.source_interface_id) | default() }}
{% endif %}
{% if ip_lookup_vrf.source_interface_type | default('') == 'Loopback' %}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/domain/lookup-settings/lookup/vrf[vrf-name='{{ ip_lookup_vrf.vrf }}']/source-interface/Loopback   {{ ip_lookup_vrf.source_interface_id | default(defaults.iosxe.configuration.system.ip_domain_lookup_vrfs.source_interface_id) | default() }}
{% endif %}
{% if ip_lookup_vrf.source_interface_type | default('') == 'Vlan' %}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/ip/domain/lookup-settings/lookup/vrf[vrf-name='{{ ip_lookup_vrf.vrf }}']/source-interface/Vlan   {{ ip_lookup_vrf.source_interface_id | default(defaults.iosxe.configuration.system.ip_domain_lookup_vrfs.source_interface_id) | default() }}
{% endif %}
{% if ip_lookup_vrf.source_interface_type | default('') == 'TenGigabitEthernet' %}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/domain/lookup-settings/lookup/vrf[vrf-name='{{ ip_lookup_vrf.vrf }}']/source-interface/TenGigabitEthernet   {{ ip_lookup_vrf.source_interface_id | default(defaults.iosxe.configuration.system.ip_domain_lookup_vrfs.source_interface_id) | default() }}
{% endif %}
{% endfor %}
{% for multicast_vrf in device.configuration.system.multicast_routing_vrfs | default([]) %}
    Should Be Equal Value Xml String   ${config}   ${sys_xpath}/ip/multicast-routing/vrf[name='{{ multicast_vrf.vrf }}']/name   {{ multicast_vrf.vrf }}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/ip/multicast-routing/vrf[name='{{ multicast_vrf.vrf }}']/distributed   {{ multicast_vrf.distributed | default(defaults.iosxe.configuration.system.multicast_routing_vrfs.distributed) | default() }}
{% endfor %}
{% if device.configuration.system.power_redundancy_mode_combined is defined %}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/power/redundancy-mode-config/combined   {{ device.configuration.system.power_redundancy_mode_combined | default(defaults.iosxe.configuration.system.power_redundancy_mode_combined) | default() }}
{% endif %}
{% if device.configuration.system.power_supply_autolc_shutdown is defined %}
    Should Be Equal Value Xml Bool   ${config}   ${sys_xpath}/power/supply/autoLC/shutdown   {{ device.configuration.system.power_supply_autolc_shutdown | default(defaults.iosxe.configuration.system.power_supply_autolc_shutdown) | default() }}
{% endif %}
{% for priority in device.configuration.system.power_supply_autolc_priority | default([]) %}
    Should Be Equal Value Xml Numeric   ${config}   ${sys_xpath}/power/supply/autoLC/priority[{{ loop.index }}]   {{ priority }}
{% endfor %}
{% endif %}
{% endfor %}
