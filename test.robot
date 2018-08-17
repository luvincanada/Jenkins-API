*** Settings ***
Library       OperatingSystem
Library       RestConf
Library    Collections

*** Variables ***
${MESSAGE}    Hello, world!

*** Test Cases ***
Get Hostname
    [Documentation]    Get host name of switch
    [Tags]    get    hostname
    ${result}=  get    system:system/config
    Should Be Equal  ${result.status_code}  ${200}
    ${json}=  Set Variable  ${result.json()}
    Log    ${json}
Put Hostname
    [Documentation]    Change host name of switch
    [Tags]    put    hostname
    ${putresult}=  put    system:system/config    {"config":{"hostname":"Switch1"}}
    Should Be Equal  ${putresult.status_code}  ${204}
    ${result}=  get    system:system/config
    Should Be Equal  ${result.status_code}  ${200}
    ${json}=  Set Variable  ${result.json()}
    Log    ${json}
    json property should equal    ${json}    openconfig-system:system    {u'config':{u'hostname':u'Switch1'}}
Patch Hostname
    [Documentation]    Change host name of switch
    [Tags]    put    hostname
    ${putresult}=  patch    system:system/config    {"config":{"hostname":"Switch1"}}
    Should Be Equal  ${putresult.status_code}  ${204}
    ${result}=  get    system:system/config
    Should Be Equal  ${result.status_code}  ${200}
    ${json}=  Set Variable  ${result.json()}
    Log    ${json}
    json property should equal    ${json}    openconfig-system:system    {u'config': {u'hostname': u'Switch1'}}  
Post Vlan
    [Documentation]    Create vlan in switch
    [Tags]    post    vlan
    ${postresult}=    post    vlan:vlans    {"vlan-id":33}
    Should Be Equal  ${postresult.status_code}  ${201}
    ${result}=  get    vlan:vlans/vlan=33/config/vlan-id
    Should Be Equal  ${result.status_code}  ${200}
    ${json}=  Set Variable  ${result.json()}
    Log    ${json}
    json property should equal    ${json}    openconfig-vlan:vlans    {u'vlan': [{u'vlan-id': 33, u'config': {u'vlan-id': 33}}]}
Patch Vlan
    [Documentation]    Update vlan in switch
    [Tags]    patch    vlan
    ${patchresult}=    patch    vlan:vlans/vlan=33/config/vlan-id    {"config":{"name":"lab-test-vlan"},"vlan-id":33}
    Should Be Equal  ${patchresult.status_code}  ${204}
    ${result}=  get    vlan:vlans/vlan=33/config/vlan-id
    Should Be Equal  ${result.status_code}  ${200}
    ${json}=  Set Variable  ${result.json()}
    Log    ${json}
    json property should equal    ${json}    openconfig-vlan:vlans    {u'vlan': [{u'vlan-id': 33, u'config': {u'vlan-id': 33}}]}   
Delete VLAN
    [Documentation]    delete vlan in switch
    [Tags]    delete    vlan
    ${delresult}=    delete    vlan:vlans/vlan=33
    Log    ${delresult.status_code}
    Should Be Equal  ${delresult.status_code}  ${204}
    ${result}=  get    vlan:vlans/vlan=33/config/vlan-id
    Should Be Equal  ${result.status_code}  ${404}
Post Log host
    [Documentation]    Post Log Host
    [Tags]    post    log
    ${postresult}=    post    system:system/oc-log:logging/oc-log:remote-servers    {"oc-log:host":"192.189.7.6"}
    Log    ${postresult.status_code}

    
*** Keywords ***
Test Setup KW
    delete    vlan:vlans/vlan=33
    
json property should equal    
    [Arguments]  ${json}  ${property}  ${value_expected}
    ${value_found} =    Get From Dictionary  ${json}  ${property}
    ${error_message} =  Catenate  SEPARATOR=  Expected value for property "  ${property}  " was "  ${value_expected}  " but found "  ${value_found}  "
    Should Be Equal As Strings  ${value_found}  ${value_expected}  ${error_message}    values=false

