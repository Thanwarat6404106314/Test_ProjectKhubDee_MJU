*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary
Resource   E:\\ProjectTest_khubdee\\Approve_points\keyword\\ApprovePoints_Keywords.robot

*** Variables ***
${URL}    http://localhost:8080/project469/
${urlApprove_points}    http://localhost:8080/project469/list-violation
${BROWSER}    Chrome
${TestData}    E:\\ProjectTest_khubdee\\Approve_points\\Data\\Data_Approve points.xlsx
${row}    4

*** Test Cases ***
TC1 Approve Points
    Open Browser    ${URL}    ${BROWSER}
    Open Excel Document    ${TestData}    doc_id=Data_Student
    Maximize Browser Window
    Login As Officer
    Click Element    //a[@id='recDropdown']
    Click Element    //a[contains(text(),'สถานะกำลังพิจารณา')]
    Set Selenium Speed    0.05

    FOR    ${i}    IN RANGE    2    ${row}+1
        ${Check}=    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
            Approve Student Points    ${i}
        END
    END

    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser
