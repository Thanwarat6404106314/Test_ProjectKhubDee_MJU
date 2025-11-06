*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Variables ***
${URL}  http://localhost:8080/project469/
${BROWSER}  Chrome
${TestData}    E:\\ProjectTest_khubdee\\Login\\Data\\TestLogin.xlsx
${row}    16


*** Test Cases ***
TC1
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Open Excel Document    ${TestData}    doc_id=login
    Set Selenium Speed    0.05  

        FOR    ${i}    IN RANGE    2    ${row}+1
        ${Check}    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
        Wait Until Element Is Visible    //a[contains(text(),'เข้าสู่ระบบ')]    3s
        Click Element    //a[contains(text(),'เข้าสู่ระบบ')]

        ${inputEmail}      Read Excel Cell    ${i}    3
        Input Text       //input[@id='email']    ${inputEmail}
        ${inputPassword}   Read Excel Cell    ${i}    4
        Input Password  //input[@id='password']    ${inputPassword}
        ${Expected_Result}     Read Excel Cell    ${i}    5
        

        Wait Until Element Is Visible    //button[@type='submit']    2s
        Click Element    //button[@type='submit']

        ${page_loaded}    Run Keyword And Return Status    Wait Until Element Is Visible    //h2[@id='swal2-title']    10s
        ${error_visible}  Run Keyword And Return Status    Page Should Contain Element    //div[@class='swal2-html-container']

            IF    ${page_loaded}
                ${Actual_Result}=    Get Text    //h2[@id='swal2-title']
            ELSE IF    ${error_visible}
                ${Actual_Result}=    Get Text    //div[@class='swal2-html-container']
            ELSE
                ${Actual_Result}=    Set Variable
            END
            
            Write Excel Cell    ${i}    6    ${Actual_Result}
        

        # ตรวจสอบผลลัพธ์
        ${flag}    Run Keyword And Return Status    Should Be Equal As Strings    ${Expected_Result}    ${Actual_Result}
        IF    ${flag}
              Write Excel Cell    ${i}     7   Pass
          ELSE    
              Write Excel Cell    ${i}    7    Fail
              
          END

        ${logout_exists}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@id='signout']   2s
        IF    ${logout_exists}
            Click Element    //button[contains(text(),'ตกลง')]
            Click Element    //a[@id='signout']
        END

        Go To    ${url}
        Wait Until Element Is Visible    //a[contains(text(),'เข้าสู่ระบบ')]    5s
        END

    END
    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser