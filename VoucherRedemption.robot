*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Library           BuiltIn
Library           VouchersLibrary

Suite Setup       Open Browser And Log In
Suite Teardown    Close All Browsers

*** Variables ***
${URL}            http://restaurant-voucher-system.com
${BROWSER}        chrome
${VALID_VOUCHER}  123456
${INVALID_VOUCHER} 654321
${USERNAME}       test_user
${PASSWORD}       test_pass

*** Test Cases ***
Full Redemption Purchase Equals Voucher Value
    [Documentation]    This test case verifies that a voucher is fully used when the purchase amount equals the voucher value.
    Apply Voucher     ${VALID_VOUCHER}     50     50
    Verify Balance    ${VALID_VOUCHER}     0

Partial Redemption Purchase Less Than Voucher Value
    [Documentation]    This test case verifies that a voucher is partially used when the purchase amount is less than the voucher value.
    Apply Voucher     ${VALID_VOUCHER}     50     30
    Verify Balance    ${VALID_VOUCHER}     20

Full Redemption Purchase More Than Voucher Value
    [Documentation]    This test case verifies that a voucher is fully used when the purchase amount is more than the voucher value.
    Apply Voucher     ${VALID_VOUCHER}     50     70
    Verify Balance    ${VALID_VOUCHER}     0
    Verify Outstanding Amount Payable    20

Voucher Invalid At Different Store
    [Documentation]    This test case verifies that a voucher cannot be used at an invalid store location.
    Apply Voucher     ${INVALID_VOUCHER}     50     50
    Verify Error Message    Voucher not valid at this location

*** Keywords ***
Open Browser And Log In
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    id=username    10 seconds
    Input Text    id=username    ${USERNAME}
    Input Text    id=password    ${PASSWORD}
    Click Button    id=login_button
    Wait Until Page Contains Element    id=vouchers_section    10 seconds

Apply Voucher
    [Arguments]    ${voucher_code}    ${voucher_value}    ${purchase_amount}
    Go To Voucher Redemption Page
    Input Text    id=voucher_code    ${voucher_code}
    Input Text    id=purchase_amount    ${purchase_amount}
    Click Button    id=redeem_button
    Sleep    2 seconds

Verify Balance
    [Arguments]    ${voucher_code}    ${expected_balance}
    Go To Voucher Balance Page
    Input Text    id=voucher_code    ${voucher_code}
    Click Button    id=check_balance_button
    Sleep    2 seconds
    ${actual_balance}=    Get Text    id=voucher_balance
    Should Be Equal As Numbers    ${actual_balance}    ${expected_balance}

Verify Outstanding Amount Payable
    [Arguments]    ${expected_outstanding}
    ${actual_outstanding}=    Get Text    id=outstanding_amount
    Should Be Equal As Numbers    ${actual_outstanding}    ${expected_outstanding}

Verify Error Message
    [Arguments]    ${expected_message}
    ${actual_message}=    Get Text    id=error_message
    Should Be Equal    ${actual_message}    ${expected_message}

Go To Voucher Redemption Page
    Click Link    id=voucher_redemption_link
    Wait Until Page Contains Element    id=voucher_code    10 seconds

Go To Voucher Balance Page
    Click Link    id=check_balance_link
    Wait Until Page Contains Element    id=voucher_code    10 seconds

