*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Variables ***
${URL}  http://localhost:8080/project469/
${urledit}    http://localhost:8080/project469/news
${BROWSER}  Chrome
${TestData}    E:\\ProjectTest_khubdee\\Edit_News\\Data\\Data_Editnew.xlsx
${row}    23

*** Test Cases ***
TC1
    Open Browser    ${url}    ${browser}
    Open Excel Document    ${TestData}    doc_id=editnew
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
        Scroll Element Into View    //body[1]/main[1]/div[3]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/a[2]
        Wait Until Element Is Visible    //div[@class='grid-container']//div[1]//div[1]//div[2]//div[1]//a[2]    2s
        Click Element    //div[@class='grid-container']//div[1]//div[1]//div[2]//div[1]//a[2]
        ${Check}    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
            ${inputnews_title}    Read Excel Cell    ${i}    3
            Input Text    //textarea[@id='news-title']    ${inputnews_title}
            ${inputDate}    Read Excel Cell    ${i}    4
            Input Text    //textarea[@id='news-desc']    ${inputDate}
            ${inputDetail}    Read Excel Cell    ${i}    5
            Input Text    //textarea[@id='news-desc']    ${inputDetail}
            ${inputImg}    Read Excel Cell    ${i}    6
            Scroll Element Into View    //input[@id='news-img']
            Choose File   //input[@id='news-img']    ${inputImg}
            ${Expected_Result}     Read Excel Cell    ${i}    7

            Scroll Element Into View    //button[contains(text(),'ยืนยัน')]
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
        
                Write Excel Cell    ${i}    8    ${Actual_Result}
            

            # ตรวจสอบผลลัพธ์
            ${flag}    Run Keyword And Return Status    Should Be Equal As Strings    ${Expected_Result}    ${Actual_Result}
            
            IF    ${flag}
                Write Excel Cell    ${i}     9   Pass
            ELSE    
                Write Excel Cell    ${i}    9   Fail
                
            END
            Go To    ${urledit}
        END
    END

    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser