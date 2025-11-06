*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Variables ***
${URL}  http://localhost:8080/project469/
${urlSearch_news}    http://localhost:8080/project469/news
${BROWSER}  Chrome
${TestData}    E:\\ProjectTest_khubdee\\Search news\\Data\\Search news_Data.xlsx
${row}    11

*** Test Cases ***
TC1
    Open Browser    ${url}    ${browser}
    Open Excel Document    ${TestData}    doc_id=Search_News
    Maximize Browser Window
    Wait Until Element Is Visible    //a[contains(text(),'เข้าสู่ระบบ')]    3s
    Click Element    //a[contains(text(),'เข้าสู่ระบบ')]
    Input Text    //input[@id='email']    officer01@mju.ac.th  
    Input Text    //input[@id='password']    mjuofficer01
    Click Element    //button[@type='submit']
    Click Element    //button[contains(text(),'ตกลง')]
    Click Element    //a[@class='p-3'][contains(text(),'ข่าวสาร')]
    Set Selenium Speed    0.05

    FOR    ${i}    IN RANGE    2    ${row}+1
        ${Check}    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
            
            ${input_Search}    Read Excel Cell    ${i}    3
            Input Text    //input[@placeholder='ค้นหาข่าว']    ${input_Search}
            

            ${Expected_Result}     Read Excel Cell    ${i}    4
            
            Wait Until Element Is Visible  //input[@value='ค้นหา']  2s
            Click Element    //input[@value='ค้นหา']


            ${Student_ID}    Run Keyword And Return Status    Wait Until Element Is Visible    //p[@class='card-title']    10s

                IF    ${Student_ID}
                    ${Actual_Result}=    Get Text    //p[@class='card-title']
                ELSE
                    ${Actual_Result}=    Set Variable
                END
            
            Write Excel Cell    ${i}    5    ${Actual_Result}

            ${flag}    Run Keyword And Return Status    Should Be Equal    ${Expected_Result}    ${Actual_Result}
            IF    ${flag}
                Capture Page Screenshot    failures3/fail_${i}.png
                Write Excel Cell    ${i}    6    Pass
            ELSE    
                Capture Page Screenshot    failures3/fail_${i}.png
                Write Excel Cell    ${i}    6   Fail
            END 


            Go To    ${urlSearch_news}
        END
    END

    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser