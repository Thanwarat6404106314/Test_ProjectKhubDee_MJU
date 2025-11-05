*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Keywords ***
Login As Officer
    Wait Until Element Is Visible    //a[contains(text(),'เข้าสู่ระบบ')]    3s
    Click Element    //a[contains(text(),'เข้าสู่ระบบ')]
    Input Text    //input[@id='email']    officer01@mju.ac.th  
    Input Text    //input[@id='password']    mjuofficer01
    Click Element    //button[@type='submit']
    Click Element    //button[contains(text(),'ตกลง')]

Add New Location
    [Arguments]    ${i}
    Wait Until Element Is Visible    //span[contains(text(),'เพิ่มสถานที่')]    2s
    Click Element    //span[contains(text(),'เพิ่มสถานที่')]

    ${inputlocation_code}=    Read Excel Cell    ${i}    3
    Input Text    //input[@id='location-id']    ${inputlocation_code}
    ${inputlocation_name}=    Read Excel Cell    ${i}    4
    Input Text    //input[@id='location-name']    ${inputlocation_name}
    ${Expected_Result}=    Read Excel Cell    ${i}    5

    Sleep    2s
    Click Element    //button[contains(text(),'เพิ่มสถานที่')]

    ${page_loaded}=    Run Keyword And Return Status    Wait Until Element Is Visible    //p[@class='h3 mb-3']    10s
    ${error_visible}=   Run Keyword And Return Status    Page Should Contain Element    //div[@id='swal2-html-container']

    IF    ${page_loaded}
        ${Actual_Result}=    Get Text    //p[@class='h3 mb-3']
    ELSE IF    ${error_visible}
        ${Actual_Result}=    Get Text    //div[@id='swal2-html-container']
    ELSE
        ${Actual_Result}=    Set Variable
    END

    Write Excel Cell    ${i}    6    ${Actual_Result}
    ${flag}=    Run Keyword And Return Status    Should Be Equal    ${Expected_Result}    ${Actual_Result}

    IF    ${flag}
        Write Excel Cell    ${i}    7    Pass
    ELSE
        Capture Page Screenshot    failures/fail_${i}.png
        Write Excel Cell    ${i}    7    Fail
    END

    Go To    ${urlAddlocation}
