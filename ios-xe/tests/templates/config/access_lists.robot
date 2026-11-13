*** Settings ***
Documentation   Verify Access Lists Configuration
Suite Setup     Run Only Once   Get Configs
Resource        ../iosxe_common.resource
Default Tags    config   iosxe   access_lists

*** Test Cases ***

{% for device in iosxe.devices | default([]) %}
{% if device.configuration.access_lists is defined %}
Get Config {{ device.name }}
    ${config}=   Get Parallel Value For Key   {{ device.name }}_config
    Set Suite Variable   ${config}
{% endif %}

{% if device.configuration.access_lists.standard is defined %}
{% for acl in device.configuration.access_lists.standard | default([]) %}
Verify Standard Access List {{ acl.name }} Device {{ device.name }}
    ${acl}=   Set Variable   data/native/ip/access-list/standard[name='{{ acl.name }}']
    Should Be Equal Value Xml String   ${config}   ${acl}/name   {{ acl.name }}
{% for entry in acl.entries | default([]) %}
    ${entry}=   Set Variable   ${acl}/access-list-seq-rule[sequence='{{ entry.sequence }}']
    Should Be Equal Value Xml String   ${config}   ${entry}/remark   {{ entry.remark | default(defaults.iosxe.configuration.access_lists.standard.entries.remark) | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/{{ entry.action | default(defaults.iosxe.configuration.access_lists.standard.entries.action) | default() }}/std-ace/ipv4-address-prefix   {{ entry.prefix | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/{{ entry.action | default(defaults.iosxe.configuration.access_lists.standard.entries.action) | default() }}/std-ace/mask   {{ entry.prefix_mask | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/{{ entry.action | default(defaults.iosxe.configuration.access_lists.standard.entries.action) | default() }}/std-ace/any   {{ entry.any | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/{{ entry.action | default(defaults.iosxe.configuration.access_lists.standard.entries.action) | default() }}/std-ace/host-address   {{ entry.host | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/{{ entry.action | default(defaults.iosxe.configuration.access_lists.standard.entries.action) | default() }}/std-ace/log   {{ entry.log | default() }}
{% endfor %}
{% endfor %}
{% endif %}

{% if device.configuration.access_lists.extended is defined %}
{% for acl in device.configuration.access_lists.extended | default([]) %}
Verify Extended Access List {{ acl.name }} Device {{ device.name }}
    ${acl}=   Set Variable   data/native/ip/access-list/extended[name='{{ acl.name }}']
    Should Be Equal Value Xml String   ${config}   ${acl}/name   {{ acl.name }}
{% for entry in acl.entries | default([]) %}
    ${entry}=   Set Variable   ${acl}/access-list-seq-rule[sequence='{{ entry.sequence }}']
    Should Be Equal Value Xml String   ${config}   ${entry}/remark   {{ entry.remark | default(defaults.iosxe.configuration.access_lists.extended.entries.remark) | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/action   {{ entry.action | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/protocol   {{ entry.protocol | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/object-group-str   {{ entry.service_object_group | default() }}
{% if entry.tcp_flags is defined and "ack" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/ack   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/ack   {{ entry.ack | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "fin" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/fin   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/fin   {{ entry.fin | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "psh" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/psh   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/psh   {{ entry.psh | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "rst" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/rst   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/rst   {{ entry.rst | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "syn" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/syn   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/syn   {{ entry.syn | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "urg" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/urg   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/urg   {{ entry.urg | default() }}
{% endif %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/established   {{ entry.established | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dscp   {{ entry.dscp | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/fragments   {{ entry.fragments | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/precedence   {{ entry.precedence | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/tos   {{ entry.tos | default() }}
{% if entry.icmp_message_type is defined %}
{% if entry.icmp_message_type is string %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/named-msg-type   {{ entry.icmp_message_type | default() }}
{% else %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/msg-type   {{ entry.icmp_message_type | default() }}
{% endif %}
{% endif %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/msg-code   {{ entry.icmp_message_code | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/log   {{ entry.log | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/log-input   {{ entry.log_input | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/ipv4-address   {{ entry.source.prefix | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/mask   {{ entry.source.prefix_mask | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/any   {{ entry.source.any | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/host-address   {{ entry.source.host | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/object-group   {{ entry.source.object_group | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-fqdn-group   {{ entry.source.fqdn_group | default() }}
{% if entry.source.port_type | default() == "equal" %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq   {{ entry.source.port | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 0 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port2   {{ entry.source.additional_equal_ports[0] | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 1 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port3   {{ entry.source.additional_equal_ports[1] | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 2 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port4   {{ entry.source.additional_equal_ports[2] | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 3 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port5   {{ entry.source.additional_equal_ports[3] | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 4 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port6   {{ entry.source.additional_equal_ports[4] | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 5 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port7   {{ entry.source.additional_equal_ports[5] | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 6 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port8   {{ entry.source.additional_equal_ports[6] | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 7 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port9   {{ entry.source.additional_equal_ports[7] | default() }}
{% endif %}
{% if entry.source.additional_equal_ports is defined and entry.source.additional_equal_ports|length > 8 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-eq-port10   {{ entry.source.additional_equal_ports[8] | default() }}
{% endif %}
{% if entry.source.port_type | default() == "greater_than" %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-gt   {{ entry.source.port | default() }}
{% endif %}
{% if entry.source.port_type | default() == "lesser_than" %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-lt   {{ entry.source.port | default() }}
{% endif %}
{% if entry.source.port_type | default() == "range" %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-range1   {{ entry.source.port_from | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/src-range2   {{ entry.source.port_to | default() }}
{% endif %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dest-ipv4-address   {{ entry.destination.prefix | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dest-mask   {{ entry.destination.prefix_mask | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/dst-any   {{ entry.destination.any | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-host-address   {{ entry.destination.host | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-object-group   {{ entry.destination.object_group | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-fqdn-group   {{ entry.destination.fqdn_group | default() }}
{% if entry.destination.port_type | default() == "equal" %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq   {{ entry.destination.port | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 0 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port2   {{ entry.destination.additional_equal_ports[0] | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 1 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port3   {{ entry.destination.additional_equal_ports[1] | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 2 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port4   {{ entry.destination.additional_equal_ports[2] | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 3 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port5   {{ entry.destination.additional_equal_ports[3] | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 4 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port6   {{ entry.destination.additional_equal_ports[4] | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 5 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port7   {{ entry.destination.additional_equal_ports[5] | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 6 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port8   {{ entry.destination.additional_equal_ports[6] | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 7 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port9   {{ entry.destination.additional_equal_ports[7] | default() }}
{% endif %}
{% if entry.destination.additional_equal_ports is defined and entry.destination.additional_equal_ports|length > 8 %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-eq-port10   {{ entry.destination.additional_equal_ports[8] | default() }}
{% endif %}
{% if entry.destination.port_type | default() == "greater_than" %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-gt   {{ entry.destination.port | default() }}
{% endif %}
{% if entry.destination.port_type | default() == "lesser_than" %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-lt   {{ entry.destination.port | default() }}
{% endif %}
{% if entry.destination.port_type | default() == "range" %}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-range1   {{ entry.destination.port_from | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dst-range2   {{ entry.destination.port_to | default() }}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}

{% if device.configuration.access_lists.as_path is defined %}
{% for acl in device.configuration.access_lists.as_path | default([]) %}
Verify AS Path Access List {{ acl.number }} Device {{ device.name }}
    ${acl_xpath}=   Set Variable   data/native/ip/as-path/access-list[name='{{ acl.number }}']
    Should Be Equal Value Xml Numeric   ${config}   ${acl_xpath}/name   {{ acl.number }}
{% for entry in acl.entries | default([]) %}
    ${entry_xpath}=   Set Variable   ${acl_xpath}/extended-grouping/extended_grouping[action='{{ entry.action | default(defaults.iosxe.configuration.access_lists.as_path.entries.action) | default() }}'][string='{{ entry.regex | default(defaults.iosxe.configuration.access_lists.as_path.entries.regex) | default() }}']
    Should Be Equal Value Xml String   ${config}   ${entry_xpath}/action   {{ entry.action | default(defaults.iosxe.configuration.access_lists.as_path.entries.action) | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry_xpath}/string   {{ entry.regex | default(defaults.iosxe.configuration.access_lists.as_path.entries.regex) | default() }}
{% endfor %}
{% endfor %}
{% endif %}

{% if device.configuration.access_lists.role_based is defined %}
{% for acl in device.configuration.access_lists.role_based | default([]) %}
Verify Role-Based Access List {{ acl.name }} Device {{ device.name }}
    ${acl}=   Set Variable   data/native/ip/access-list/role-based[name='{{ acl.name }}']
    Should Be Equal Value Xml String   ${config}   ${acl}/name   {{ acl.name }}
{% for entry in acl.entries | default([]) %}
    ${entry}=   Set Variable   ${acl}/access-list-seq-rule[sequence='{{ entry.sequence }}']
    Should Be Equal Value Xml String   ${config}   ${entry}/remark   {{ entry.remark | default(defaults.iosxe.configuration.access_lists.role_based.entries.remark) | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/action   {{ entry.action | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/protocol   {{ entry.protocol | default() }}
{% if entry.tcp_flags is defined and "ack" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/ack   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/ack   {{ entry.ack | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "fin" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/fin   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/fin   {{ entry.fin | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "psh" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/psh   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/psh   {{ entry.psh | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "rst" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/rst   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/rst   {{ entry.rst | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "syn" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/syn   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/syn   {{ entry.syn | default() }}
{% endif %}
{% if entry.tcp_flags is defined and "urg" in entry.tcp_flags %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/urg   true
{% else %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/urg   {{ entry.urg | default() }}
{% endif %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/established   {{ entry.established | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/fragments   {{ entry.fragments | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/dscp   {{ entry.dscp | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/precedence   {{ entry.precedence | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/tos   {{ entry.tos | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/option   {{ entry.option | default() }}
    Should Be Equal Value Xml String   ${config}   ${entry}/ace-rule/time-range   {{ entry.time_range | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/log   {{ entry.log | default() }}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/log-input   {{ entry.log_input | default() }}
{% if entry.match_all is defined and "+ack" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/plusack   true
{% endif %}
{% if entry.match_all is defined and "+fin" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/plusfin   true
{% endif %}
{% if entry.match_all is defined and "+psh" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/pluspsh   true
{% endif %}
{% if entry.match_all is defined and "+rst" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/plusrst   true
{% endif %}
{% if entry.match_all is defined and "+syn" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/plussyn   true
{% endif %}
{% if entry.match_all is defined and "+urg" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/plusurg   true
{% endif %}
{% if entry.match_all is defined and "-ack" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/minusack   true
{% endif %}
{% if entry.match_all is defined and "-fin" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/minusfin   true
{% endif %}
{% if entry.match_all is defined and "-psh" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/minuspsh   true
{% endif %}
{% if entry.match_all is defined and "-rst" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/minusrst   true
{% endif %}
{% if entry.match_all is defined and "-syn" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/minussyn   true
{% endif %}
{% if entry.match_all is defined and "-urg" in entry.match_all %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-all/minusurg   true
{% endif %}
{% if entry.match_any is defined and "+ack" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/plusack   true
{% endif %}
{% if entry.match_any is defined and "+fin" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/plusfin   true
{% endif %}
{% if entry.match_any is defined and "+psh" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/pluspsh   true
{% endif %}
{% if entry.match_any is defined and "+rst" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/plusrst   true
{% endif %}
{% if entry.match_any is defined and "+syn" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/plussyn   true
{% endif %}
{% if entry.match_any is defined and "+urg" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/plusurg   true
{% endif %}
{% if entry.match_any is defined and "-ack" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/minusack   true
{% endif %}
{% if entry.match_any is defined and "-fin" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/minusfin   true
{% endif %}
{% if entry.match_any is defined and "-psh" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/minuspsh   true
{% endif %}
{% if entry.match_any is defined and "-rst" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/minusrst   true
{% endif %}
{% if entry.match_any is defined and "-syn" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/minussyn   true
{% endif %}
{% if entry.match_any is defined and "-urg" in entry.match_any %}
    Should Be Equal Value Xml Bool   ${config}   ${entry}/ace-rule/match-any/minusurg   true
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
{% endfor %}
