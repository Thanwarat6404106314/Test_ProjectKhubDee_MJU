*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary

*** Keywords ***
Login As Officer
    [Documentation]    
    Wait Until Element Is Visible    //a[contains(text(),'เข้าสู่ระบบ')]    3s
    Click Element    //a[contains(text(),'เข้าสู่ระบบ')]
    Input Text    //input[@id='email']    officer01@mju.ac.th 
    Input Text    //input[@id='password']    mjuofficer01
    Click Element    //button[@type='submit']
    Wait Until Element Is Visible    //button[contains(text(),'ตกลง')]    5s
    Click Element    //button[contains(text(),'ตกลง')]


Add News Item
    [Documentation]    
    [Arguments]    ${i}

    ${news_title}=    Read Excel Cell    ${i}    3
    ${news_date}=     Read Excel Cell    ${i}    4
    ${news_detail}=   Read Excel Cell    ${i}    5
    ${news_img}=      Read Excel Cell    ${i}    6
    ${expected_result}=    Read Excel Cell    ${i}    7

    Wait Until Element Is Visible    //input[@id='news-title']    5s
    Input Text    //input[@id='news-title']    ${news_title}
    Input Text    //input[@id='news-date']     ${news_date}
    Input Text    //textarea[@id='news-detail']    ${news_detail}
    Run Keyword And Ignore Error    Choose File    //input[@id='news-img']    ${news_img}

    Scroll Element Into View    //button[contains(text(),'เพิ่มข่าว')]
    Sleep    1s
    Click Element    //button[contains(text(),'เพิ่มข่าว')]

    ${page_loaded}=    Run Keyword And Return Status    Wait Until Element Is Visible    //p[@class='h3 mb-3']    10s
    IF    ${page_loaded}
        ${actual_result}=    Get Text    //p[@class='h3 mb-3']
    ELSE
        ${actual_result}=    Set Variable    เพิ่มข่าวไม่สำเร็จ
    END

    Write Excel Cell    ${i}    8    ${actual_result}

    ${flag}=    Run Keyword And Return Status    Should Be Equal As Strings    ${expected_result}    ${actual_result}
    IF    ${flag}
        Write Excel Cell    ${i}    9    Pass
    ELSE
        Capture Page Screenshot    failures3/fail_${i}.png
        Write Excel Cell    ${i}    9    Fail
    END
