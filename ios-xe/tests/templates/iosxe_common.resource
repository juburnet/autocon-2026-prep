*** Settings ***
Library   pabot.PabotLib
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   OperatingSystem
Library   ./lib/UtilsLib.py

*** Keywords ***
Login IOSXE
    ${auth}=   Create List   %{IOSXE_USERNAME}   %{IOSXE_PASSWORD}
    ${iosxe_insecure}=   Get Environment Variable   IOSXE_INSECURE   True
    ${verify}=   Set Variable If   '${iosxe_insecure}' == 'True' or '${iosxe_insecure}' == 'true'   False   True
{% for device in iosxe.devices | default([]) %}
    Create Session   IOSXE_{{ device.name }}   {{ 'https://' ~ device.host | default(device.url) }}   auth=${auth}   verify=${verify}   headers={"Accept": "application/yang-data+json", "Content-Type": "application/yang-data+json"}
{% endfor %}

Should Be Equal Value Json String
    [Arguments]   ${json}   ${json_path}   ${value}=${EMPTY}
    ${length}=   Get Length   ${value}
    IF   ${length} == 0   RETURN
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    ${r_value}=   Normalize String   text=${r_value}
    ${value}=   Normalize String   text=${value}
    Should Be Equal As Strings   ${r_value}   ${value}

Should Be Equal Value Json List
    [Arguments]   ${json}   ${json_path}   ${value}=${EMPTY}   ${normalize_types}=${False}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    IF   ${r_value} == [] or ${value} == [] or "${value}" == "${EMPTY}"
        RETURN
    END
    IF   ${normalize_types}
        # Convert both lists to strings for type-insensitive comparison
        ${r_value_str}=   Evaluate   [str(x) for x in ${r_value}[0]]
        ${value_str}=   Evaluate   [str(x) for x in ${value}]
        Lists Should Be Equal   ${r_value_str}   ${value_str}   ignore_order=True
    ELSE
        Lists Should Be Equal   ${r_value}[0]   ${value}   ignore_order=True
    END

Should Be Equal Value Json Bool
    [Arguments]   ${json}   ${json_path}   ${value}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    IF   "${value}" == "${EMPTY}"
        RETURN
    END
    IF   "${value}" == "True"
        IF   ${r_value} == []   Fail   Expected True but got nothing
        IF   ${r_value}[0] == [None]   RETURN
        IF   ${r_value}[0] == ${True}   RETURN
        IF   ${r_value}[0] != ""  RETURN
        Fail   Expected True but got ${r_value}[0]
    ELSE IF   "${value}" == "False"
        IF   ${r_value} == []   RETURN
        IF   ${r_value}[0] == ${False}   RETURN
        Fail   Expected False but got ${r_value}[0]
    END
