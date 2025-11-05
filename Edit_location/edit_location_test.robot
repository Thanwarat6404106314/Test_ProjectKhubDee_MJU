*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary
Resource   E:\\ProjectTest_khubdee\\Edit_location\\keyword\\edit_location_keywords.robot

*** Variables ***
${URL}               http://localhost:8080/project469/
${urlAddlocation}    http://localhost:8080/project469/location
${BROWSER}           Chrome
${TestData}          E:\\ProjectTest_khubdee\\Edit_location\\Data\\Edit_Location.xlsx
${row}               6

*** Test Cases ***
TC1 Edit Location Data
    [Documentation]    
    Open Browser And Login
    Edit Location From Excel
    Save Excel Document    ${TestData}
    Close Current Excel Document
    Sleep    2s
    Close Browser
