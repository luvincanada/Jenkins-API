*** Settings ***
Library       OperatingSystem
Library       RestConf
Library    Collections

*** Variables ***
${MESSAGE}    Hello, world!

*** Test Cases ***
Verify Hostname
    ${result}=  get    get?foo1=bar1&foo2=bar2 
    Should Be Equal  ${result.status_code}  ${200}
    ${json}=  Set Variable  ${result.json()}
    Log    ${json}
    json property should equal    ${json}    args    {u'content': u'config', u'foo1': u'bar1', u'foo2': u'bar2'}
    
Verify Post
    ${result}=  post    post    {"id": "1"}
    Should Be Equal  ${result.status_code}  ${200}
    ${json}=  Set Variable  ${result.json()}
    Log    ${json}
    json property should equal    ${json}    data    {u'id': u'1'}  
    
*** Keywords ***
json_property_should_equal    
    [Arguments]  ${json}  ${property}  ${value_expected}
    ${value_found} =    Get From Dictionary  ${json}  ${property}
    ${error_message} =  Catenate  SEPARATOR=  Expected value for property "  ${property}  " was "  ${value_expected}  " but found "  ${value_found}  "
    Should Be Equal As Strings  ${value_found}  ${value_expected}  ${error_message}    values=false

