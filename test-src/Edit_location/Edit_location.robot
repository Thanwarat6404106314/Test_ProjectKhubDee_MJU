*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Variables ***
${URL}  http://localhost:8080/project469/
${urlAddlocation}    http://localhost:8080/project469/location
${BROWSER}  Chrome
${TestData}    E:\\ProjectTest_khubdee\\Edit_location\\Data\\Edit_Location.xlsx
${row}    6

*** Test Cases ***
TC1
    Open Browser    ${url}    ${browser}
    Open Excel Document    ${TestData}    doc_id=addlocation
    Maximize Browser Window
    Wait Until Element Is Visible    //a[contains(text(),'เข้าสู่ระบบ')]    3s
    Click Element    //a[contains(text(),'เข้าสู่ระบบ')]
    Input Text    //input[@id='email']    officer01@mju.ac.th  
    Input Text    //input[@id='password']    mjuofficer01
    Click Element    //button[@type='submit']
    Click Element    //button[contains(text(),'ตกลง')]
    Click Element    //a[contains(text(),'สถานที่')]

    
    Set Selenium Speed    0.05

    FOR    ${i}    IN RANGE    2    ${row}+1
        ${Check}    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
            Wait Until Element Is Visible    //body[1]/main[1]/div[2]/div[2]/table[1]/tbody[1]/tr[5]/td[3]/a[1]    2s
            Click Element    //body[1]/main[1]/div[2]/div[2]/table[1]/tbody[1]/tr[5]/td[3]/a[1]
            ${inputlocation_name}    Read Excel Cell    ${i}    3
            Input Text    //input[@id='location-name']    ${inputlocation_name}
            ${Expected_Result}     Read Excel Cell    ${i}    4
            
            Sleep    2s
            Click Element    //button[contains(text(),'ยืนยัน')]

            ${page_loaded}    Run Keyword And Return Status    Wait Until Element Is Visible    //p[@class='h3 mb-3']    10s
            ${error_visible}  Run Keyword And Return Status    Page Should Contain Element    //div[@id='swal2-html-container']
                    
                IF    ${page_loaded}
                    ${Actual_Result}=    Get Text    //p[@class='h3 mb-3']
                ELSE IF    ${error_visible}
                    ${Actual_Result}=    Get Text    //div[@id='swal2-html-container']
                ELSE
                    ${Actual_Result}=    Set Variable
                END
            
            Write Excel Cell    ${i}    5    ${Actual_Result}

            ${flag}    Run Keyword And Return Status    Should Be Equal    ${Expected_Result}    ${Actual_Result}
            IF    ${flag}
                Write Excel Cell    ${i}    6    Pass
            ELSE    
                Capture Page Screenshot    failures/fail_${i}.png
                Write Excel Cell    ${i}    6    Fail
            END 

            Go To    ${urlAddlocation}
        END
    END

    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser