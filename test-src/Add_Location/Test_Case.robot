*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary
Resource   Keyword_location.robot

*** Variables ***
${URL}    http://localhost:8080/project469/
${urlAddlocation}    http://localhost:8080/project469/location
${BROWSER}    Chrome
${TestData}    E:\\ProjectTest_khubdee\\Add_Location\\Data\\Data_Addlocation.xlsx
${row}    15

*** Test Cases ***
TC1 Add Location
    Open Browser    ${URL}    ${BROWSER}
    Open Excel Document    ${TestData}    doc_id=addlocation
    Maximize Browser Window
    Login As Officer
    Click Element    //a[contains(text(),'สถานที่')]
    Set Selenium Speed    0.05

    FOR    ${i}    IN RANGE    2    ${row}+1
        ${Check}=    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
            Add New Location    ${i}
        END
    END

    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser
