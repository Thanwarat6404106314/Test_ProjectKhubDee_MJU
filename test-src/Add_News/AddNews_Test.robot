*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary
Resource   AddNews_Keywords.robot

*** Variables ***
${URL}    http://localhost:8080/project469/
${urlAddnews}    http://localhost:8080/project469/viewAddNews
${BROWSER}    Chrome
${TestData}    E:\\ProjectTest_khubdee\\Add_News\\Data\\data_Addnew.xlsx
${row}    24

*** Test Cases ***
TC1 Add News
    Open Browser    ${URL}    ${BROWSER}
    Open Excel Document    ${TestData}    doc_id=addnews
    Maximize Browser Window
    Login As Officer
    click_add

    FOR    ${i}    IN RANGE    2    ${row}+1
        ${Check}=    Read Excel Cell    ${i}    1
        IF    '${Check}' == 'Y'
            Add News Item    ${i}
            Click add news
            Get Result
        END
        Go To    ${urlAddnews}
    END

    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser
    