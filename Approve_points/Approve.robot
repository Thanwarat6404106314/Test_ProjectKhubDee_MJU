*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Variables ***
${URL}  http://localhost:8080/project469/
${urlApprove_points}    http://localhost:8080/project469/list-violation
${BROWSER}  Chrome
${TestData}    E:\\ProjectTest_khubdee\\Approve_points\\Data\\Data_Approve points.xlsx
${row}    4

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
            
            ${Approve_Select}    Read Excel Cell    ${i}    3
            Select From List By Value    //select[@name='status-type']    ${Approve_Select}
            

            ${Expected_Result}     Read Excel Cell    ${i}    4
            
            Wait Until Element Is Visible  //button[@type='submit'][contains(text(),'บันทึก')][1]  2s
            Click Element    //button[@type='submit'][contains(text(),'บันทึก')][1]

            Wait Until Element Is Visible    //button[contains(text(),'ยืนยัน')]    2s
            Click Element    //button[contains(text(),'ยืนยัน')]


            ${Student_ID}    Run Keyword And Return Status    Wait Until Element Is Visible    //p[@class='h3 mb-3']    10s
            ${error_visible}  Run Keyword And Return Status    Page Should Contain Element    //div[@id='swal2-html-container']
                    
                IF    ${Student_ID}
                    ${Actual_Result}=    Get Text    //td[normalize-space()][2]
                ELSE IF    ${error_visible}
                ${Actual_Result}=    Get Text    //div[@id='swal2-html-container']
                ELSE
                    ${Actual_Result}=    Set Variable
                END
            
            Write Excel Cell    ${i}    5    ${Actual_Result}

            ${flag}    Run Keyword And Return Status    Should Be Equal    ${Expected_Result}    ${Actual_Result}
            IF    ${flag}
                Capture Page Screenshot    failures2/fail_${i}.png
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