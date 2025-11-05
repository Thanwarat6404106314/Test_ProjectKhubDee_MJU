*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Variables ***
${URL}  http://localhost:8080/project469/
${urlApprove_points}    http://localhost:8080/project469/list-violation
${BROWSER}  Chrome
${TestData}    E:\\ProjectTest_khubdee\\Approve_points\\Data\\Data_Student.xlsx
${row}    13

*** Test Cases ***
TC1
    Open Browser    ${url}    ${browser}
    Open Excel Document    ${TestData}    doc_id=Data_Student
    Maximize Browser Window
    Wait Until Element Is Visible    //a[contains(text(),'เข้าสู่ระบบ')]    3s
    Click Element    //a[contains(text(),'เข้าสู่ระบบ')]
    Input Text    //input[@id='email']    officer01@mju.ac.th  
    Input Text    //input[@id='password']    mjuofficer01
    Click Element    //button[@type='submit']
    Click Element    //button[contains(text(),'ตกลง')]
    Click Element   //a[@id='recDropdown']
    Click Element    //a[contains(text(),'สถานะกำลังพิจารณา')]
    Set Selenium Speed    0.05

    FOR    ${i}    IN RANGE    2    ${row}+1
        ${Check}    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
            
            ${input_type}    Read Excel Cell    ${i}    3
            Input Text    //input[@placeholder='ค้นหารหัสนักศึกษาหรือข้อมูลของนักศึกษา']    ${input_type}
            

            ${Expected_Result}     Read Excel Cell    ${i}    4
            
            Wait Until Element Is Visible  //input[@value='ค้นหา']  2s
            Click Element    //input[@value='ค้นหา']


            ${Student_ID}    Run Keyword And Return Status    Wait Until Element Is Visible    //td[normalize-space()][2]    10s
            ${error_visible}  Run Keyword And Return Status    Page Should Contain Element    //strong[contains(text(),'ไม่พบข้อมูล')]
                    
                IF    ${Student_ID}
                    ${Actual_Result}=    Get Text    //td[normalize-space()][2]
                ELSE IF    ${error_visible}
                    ${Actual_Result}=    Get Text    //strong[contains(text(),'ไม่พบข้อมูล')]
                ELSE
                    ${Actual_Result}=    Set Variable
                END
            
            Write Excel Cell    ${i}    5    ${Actual_Result}

            ${flag}    Run Keyword And Return Status    Should Be Equal    ${Expected_Result}    ${Actual_Result}
            IF    ${flag}
                Write Excel Cell    ${i}    6    Pass
            ELSE    
                Capture Page Screenshot    failures2/fail_${i}.png
                Write Excel Cell    ${i}    6   Fail
            END 


            Go To    ${urlApprove_points}
        END
    END

    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser