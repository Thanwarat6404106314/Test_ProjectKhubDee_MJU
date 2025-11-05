*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Variables ***
${URL}  http://localhost:8080/project469/
${urlAddnews}    http://localhost:8080/project469/viewAddNews
${BROWSER}  Chrome
${TestData}    E:\\ProjectTest_khubdee\\Add_News\\Data\\data_Addnew.xlsx
${row}    24

*** Test Cases ***
TC1
    Open Browser    ${url}    ${browser}
    Open Excel Document    ${TestData}    doc_id=addnews
    Maximize Browser Window
    Wait Until Element Is Visible    //a[contains(text(),'เข้าสู่ระบบ')]    3s
    Click Element    //a[contains(text(),'เข้าสู่ระบบ')]
    Input Text    //input[@id='email']    officer01@mju.ac.th 
    Input Text    //input[@id='password']    mjuofficer01
    Click Element    //button[@type='submit']
    Click Element    //button[contains(text(),'ตกลง')]
    Click Element    //a[@class='p-3'][contains(text(),'ข่าวสาร')]
    Set Selenium Speed    0.05
    Wait Until Element Is Visible    //span[contains(text(),'เพิ่มข่าว')]    2s
    Click Element    //span[contains(text(),'เพิ่มข่าว')]
    FOR    ${i}    IN RANGE    2    ${row}+1
        ${Check}    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
            ${inputnews_title}    Read Excel Cell    ${i}    3
            Input Text    //input[@id='news-title']    ${inputnews_title}
            ${inputDate}    Read Excel Cell    ${i}    4
            Input Text    //input[@id='news-date']    ${inputDate}
            ${inputDetail}    Read Excel Cell    ${i}    5
            Input Text    //textarea[@id='news-detail']    ${inputDetail}
            ${inputImg}    Read Excel Cell    ${i}    6
            Run Keyword And Ignore Error  Choose File   //input[@id='news-img']    ${inputImg}
            ${Expected_Result}     Read Excel Cell    ${i}    7

            Scroll Element Into View    //button[contains(text(),'เพิ่มข่าว')]
            Sleep    2s
            Click Element    //button[contains(text(),'เพิ่มข่าว')]

            ${page_loaded}    Run Keyword And Return Status    Wait Until Element Is Visible    //p[@class='h3 mb-3']    10s
             

                IF    ${page_loaded}
                    ${Actual_Result}=    Get Text    //p[@class='h3 mb-3']
                ELSE
                    ${Actual_Result}=    Set Variable
                END
                
                Write Excel Cell    ${i}    8    ${Actual_Result}
            

            # ตรวจสอบผลลัพธ์
            ${flag}    Run Keyword And Return Status    Should Be Equal As Strings    ${Expected_Result}    ${Actual_Result}
            IF    ${flag}
                Write Excel Cell    ${i}     9   Pass
            ELSE    
                Write Excel Cell    ${i}    9    Fail
                
            END
        

            Go To    ${urlAddnews}
        END
    END

    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser