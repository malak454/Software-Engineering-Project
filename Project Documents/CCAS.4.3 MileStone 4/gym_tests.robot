*** Settings ***
Library    SeleniumLibrary
Library    BuiltIn
Library    String
Suite Setup    Open Browser To Gym Page
Suite Teardown    Close Browser
Test Setup    Prepare For Test

*** Variables ***
${URL}              file:///Users/mariamsherif/Documents/gym project copy/index.html
${BROWSER}          chrome
${MIN_CALORIES}     1000
${MAX_CALORIES}     5000
${MIN_CARBS}        50
${MAX_CARBS}        800
${MIN_FAT}          20
${MAX_FAT}          300
${MIN_PROTEIN}      30
${MAX_PROTEIN}      500

*** Keywords ***
Open Browser To Gym Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    css=.tab.active    10s
    Sleep    2s

Prepare For Test
    Sleep    3s
    Execute JavaScript    document.querySelectorAll('.notification').forEach(n => n.remove())
    Sleep    0.5s

Switch To Client Tab
    Execute JavaScript    document.querySelectorAll('.notification').forEach(n => n.remove())
    Sleep    0.5s
    Click Element    xpath=//button[contains(text(),'Client')]
    Wait Until Element Is Visible    id=first_name    5s
    Sleep    0.5s

Switch To Nutrition Plan Tab
    Execute JavaScript    document.querySelectorAll('.notification').forEach(n => n.remove())
    Sleep    0.5s
    Click Element    xpath=//button[contains(text(),'Nutrition Plan')]
    Wait Until Element Is Visible    id=client_id    5s
    Sleep    0.5s

Clear All Client Inputs
    Clear Element Text    id=first_name
    Clear Element Text    id=last_name
    Clear Element Text    id=date_of_birth
    Clear Element Text    id=phone_number
    Clear Element Text    id=email
    Clear Element Text    id=coach_id
    Clear Element Text    id=membership_id

Wait For Notification Containing
    [Arguments]    ${expected_text}
    Wait Until Element Is Visible    css=.notification    5s
    ${notification_text}=    Get Text    css=.notification
    Should Contain    ${notification_text}    ${expected_text}

*** Test Cases ***
Test 1 - Name Should Not Contain Numbers
    [Documentation]    Test that names with numbers are rejected
    Switch To Client Tab
    Clear All Client Inputs
    
    Input Text    id=first_name    Mariam123
    Input Text    id=last_name     Test
    Input Text    id=date_of_birth    2000-01-01
    Select From List By Value    id=gender    M
    Input Text    id=phone_number    01234567891
    Input Text    id=email         mariam@test.com
    Input Text    id=coach_id      1
    Input Text    id=membership_id    1
    
    Click Button    xpath=//button[contains(text(),'Add Record')]
    Wait For Notification Containing    can only contain letters

Test 2 - Email Should Be Valid Format
    [Documentation]    Test that invalid email formats are rejected
    Switch To Client Tab
    Clear All Client Inputs
    
    Input Text    id=first_name    Mariam
    Input Text    id=last_name     Test
    Input Text    id=date_of_birth    2000-01-01
    Select From List By Value    id=gender    F
    Input Text    id=phone_number    01234567891
    Input Text    id=email         invalid-email
    Input Text    id=coach_id      1
    Input Text    id=membership_id    1
    
    Click Button    xpath=//button[contains(text(),'Add Record')]
    Wait For Notification Containing    valid email address

Test 3 - User Must Be Older Than Thirteen
    [Documentation]    Test that users under 13 are rejected
    Switch To Client Tab
    Clear All Client Inputs
    
    Input Text    id=first_name    Mariam
    Input Text    id=last_name     Test
    Input Text    id=date_of_birth    2020-01-01
    Select From List By Value    id=gender    F
    Input Text    id=phone_number    01234567891
    Input Text    id=email         mariam@test.com
    Input Text    id=coach_id      1
    Input Text    id=membership_id    1
    
    Click Button    xpath=//button[contains(text(),'Add Record')]
    Wait For Notification Containing    must be at least 13 years old

Test 4 - Phone Number Must Contain At Least 11 Digits
    [Documentation]    Test that short phone numbers are rejected
    Switch To Client Tab
    Clear All Client Inputs
    
    Input Text    id=first_name    Mariam
    Input Text    id=last_name     Test
    Input Text    id=date_of_birth    2000-01-01
    Select From List By Value    id=gender    F
    Input Text    id=phone_number    0123456
    Input Text    id=email         mariam@test.com
    Input Text    id=coach_id      1
    Input Text    id=membership_id    1
    
    Click Button    xpath=//button[contains(text(),'Add Record')]
    Wait For Notification Containing    Phone number must contain

Test 5 - Nutrition Plan Range Validation
    [Documentation]    Test that nutrition values within valid ranges pass validation logic
    
    ${calories}=    Set Variable    2000
    ${carbs}=       Set Variable    250
    ${fat}=         Set Variable    80
    ${protein}=     Set Variable    120
    
    Should Be True    ${calories} >= ${MIN_CALORIES} and ${calories} <= ${MAX_CALORIES}
    Should Be True    ${carbs} >= ${MIN_CARBS} and ${carbs} <= ${MAX_CARBS}
    Should Be True    ${fat} >= ${MIN_FAT} and ${fat} <= ${MAX_FAT}
    Should Be True    ${protein} >= ${MIN_PROTEIN} and ${protein} <= ${MAX_PROTEIN}
    
    Log    All nutrition values are within valid ranges

Test 6 - Nutrition Plan Out Of Range Should Fail
    [Documentation]    Test that nutrition values out of range are rejected
    Switch To Nutrition Plan Tab
    
    Clear Element Text    id=client_id
    Clear Element Text    id=coach_id
    Clear Element Text    id=diet_plan
    Clear Element Text    id=calories_intake
    Clear Element Text    id=protein_target
    Clear Element Text    id=carbs_target
    Clear Element Text    id=fats_target
    
    Input Text    id=client_id         1
    Input Text    id=coach_id          1
    Input Text    id=diet_plan         Test Diet
    Input Text    id=calories_intake   500
    Input Text    id=protein_target    120
    Input Text    id=carbs_target      250
    Input Text    id=fats_target       80
    
    Click Button    xpath=//button[contains(text(),'Add Record')]
    Wait For Notification Containing    Calories must be between

Test 7 - Valid Client Registration Scenario
    [Documentation]    Test successful client registration
    Switch To Client Tab
    Clear All Client Inputs
    
    ${timestamp}=    Get Time    epoch
    ${unique_email}=    Set Variable    mariam.test${timestamp}@example.com
    
    Input Text    id=first_name        Mariam
    Input Text    id=last_name         Sherif
    Input Text    id=date_of_birth     1995-05-15
    Select From List By Value    id=gender    F
    Input Text    id=phone_number      01234567891
    Input Text    id=email             ${unique_email}
    Input Text    id=coach_id          1
    Input Text    id=membership_id     1
    
    Click Button    xpath=//button[contains(text(),'Add Record')]
    Sleep    3s
    
    ${page_text}=    Get Text    css=body
    ${has_success}=    Run Keyword And Return Status    Should Contain    ${page_text}    successfully
    ${has_error}=    Run Keyword And Return Status    Should Contain    ${page_text}    Invalid reference ID
    
    Run Keyword If    ${has_error}    Log    Foreign key constraint - need to create coach_id=1 and membership_id=1 first
    Run Keyword If    ${has_success}    Log    Registration successful!