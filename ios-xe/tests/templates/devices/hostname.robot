
*** Test Cases ***
{% for device in iosxe.devices | default([], true) %}
{% if device.variables is defined and device.variables.HOSTNAME is defined %}
Verify {{ device.name }}//hostname
    ${hostname}=    Get Hostname    {{ device.host }}
    Should Be Equal As Strings    ${hostname}    {{ device.variables.HOSTNAME }}

{% endif %}
{% endfor %}
