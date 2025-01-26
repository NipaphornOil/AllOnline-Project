*** Setting ***
Library    SeleniumLibrary
Library    String

Test Setup    Open web All Online and sign on email
Test Teardown    Close All Browsers

*** Variables ***
${URL}    https://www.allonline.7eleven.co.th/    #https://www-allonline-uat.cpall.co.th/
${BROWSER}    chrome
${email}    oilallonline.work@gmail.com
${password}    oilallonline@testxxx000
${BTN_SIGNON_WEB}    xpath=//*[@id="page"]/header/div[4]/div/div/div/ul/li[4]/a    #//*[@id="page"]/header/div[4]/div/div/div/ul/li[5]/a
${BTN_SIGNON_Email}    xpath=//*[@id="__next"]//a[@class="btn btn-small" and contains(text(),"เข้าสู่ระบบ")]
${BTN_SKIP}    xpath=//*[@id="__next"]//button[text()="ข้าม"]
${INP_SEARCH_BOX}    xpath=//*[@name="q"]
${BTN_SEARCH}    xpath=//button[@class="btn btn-default search" and @type="submit"]
${IMG_PRODUCT}    xpath=//*[@id="page"]//div[contains(text(),"ไมโลบาร์ ช็อกโกแลต 30 กรัม")]
${BTN_AddToCart}    xpath=//*[@id="article-form"]/div[2]/div[2]/div[4]/div[1]/button
${ICON_MINI_BASKET}    xpath=//*[@id="mini-basket"]//span[@class="cart-indicator"]
${BTN_PAYMENT}    xpath=//*[@id="mini-basket-val"]//a[contains(text(),"ชำระค่าสินค้า")]
${INP_PHONENO}    id:second-phone-shipping
${BTN_SEARCH_BY_STORE}    xpath=//*[@id="storefinder-selector-group"]//button[contains(.,"ค้นหาผ่านรหัสร้าน เซเว่นอีเลฟเว่น ( 7-11 )")]
${INP_BRANCH_CODE}    id:user-storenumber-input
${BTN_CONFIRM_STORE_CODE}    id:btn-check-storenumber
${LABEL_STORE_YOU_CHOOSE}    xpath=//*[@id="selected-store-title"]/h3[text()="สาขาที่ท่านเลือก"]
${BTN_CONT_PAYMENT}    id:continue-payment-btn
${BTN_DEBIT}    xpath=//*[@id="payment-options"]//*[contains(text(),"ชำระเงินด้วยบัตรเครดิต หรือ บัตรเดบิต")]
${LABEL_CUSTOMER_NAME}    xpath=//*[@id="login-dropdown"]/span[1]
${LABEL_ORDER_SUCCESS}    xpath=//*[@id="stepModel"]//div[@class="h3" and contains(.,"สรุปรายการสั่งซื้อ")]
${LABEL_ORDER_SUCCESS_CUSTOMER_NAME}    xpath=//*[@id="stepModel"]//div[@class="invoice-address-wrapper"]
${LABEL_ORDER_SUCCESS_STORE_NAME}    xpath=//*[@id="stepModel"]//span[@class="address ellipsis-full "]/span[contains(.,"เซเว่นอีเลฟเว่น")]
${LABEL_ORDER_SUCCESS_PRICE}    xpath=//*[@id="js-invoice-details-tbody"]//td[@class="currency"]/b[@class="font-normal" and contains(.,"฿ ")]    #//*[@id="js-invoice-details-tbody"]/tr[@class="price normal-specia"]//*[text()="ราคา"]


*** Test Cases ***
Order products and pick up and payment with a debit card    #ลูกค้าสั่งซื้อสินค้าเลือกรับที่ร้านและชำระเงินด้วยบัตรเดบิต
    ${product_search}    ${get_customer_name}    Search product name    ไมโลบาร์ ช็อกโกแลต 30 กรัม
    Verify search result and select product to buy    ${product_search}
    ${expected_result_basket}    Verify product detail and add to cart    ${product_search}    1
    Click payment button    
    ${store_code}    Verify detail shipping and pick up in store    รายละเอียดการจัดส่งสินค้า    0802063006    00903  
    Click continue to payment button
    Verify payment method
    Summary order    ${expected_result_basket}    ${get_customer_name}    ${store_code}    


*** Keywords ***
Open web All Online and sign on email
    Open Browser    url=${URL}    browser=${BROWSER}
    Maximize Browser Window
    #กดปุ่ม เข้าสู่ระบบ Web
    Click Element    locator=${BTN_SIGNON_WEB}
    #กรอก username
    Wait Until Element Is Visible    name=email
    Input Text    name=email    ${email}
    #กรอก password
    Wait Until Element Is Visible    name=password
    Input Text    name=password    ${password}
    #กดปุ่ม เข้าสู่ระบบ Email
    Click Element    ${BTN_SIGNON_Email}
    Capture Page Screenshot
    #กดปุ่ม Skip
    Wait Until Element Is Visible    ${BTN_SKIP}
    Click Element    ${BTN_SKIP}
    Capture Page Screenshot


Search product name  
    [Arguments]    ${product_search}
    #ตรวจสอบชื่อลูกค้า/ sign on
    Wait Until Element Is Visible    ${LABEL_CUSTOMER_NAME}    #xpath//*[@id="login-dropdown"]/span[text()="Hello Test"]
    ${get_customer_name}=    Get Text    locator=${LABEL_CUSTOMER_NAME}
    Log To Console    CUSTOMER NAME: "${get_customer_name}"
    #ตรวจสอบการค้นหาสินค้า
    Wait Until Element Is Visible    id:search_id_form
    Input Text    ${INP_SEARCH_BOX}    ${product_search}
    Click Element    ${BTN_SEARCH}
    Capture Page Screenshot
    [Return]    ${product_search}    ${get_customer_name}

Verify search result and select product to buy
    [Arguments]    ${expected_result}  
    Wait Until Page Contains    ${expected_result}
    Click Element    locator=${IMG_PRODUCT}
    Capture Page Screenshot


Verify product detail and add to cart
    [Arguments]    ${expected_result_product}    ${expected_result_basket}
    Wait Until Page Contains    ${expected_result_product}
    #กดปุ่ม เพิ่มในตะกร้า
    Click Element    locator=${BTN_AddToCart}
    #ตรวจสอบการแสดงจำนวนสินค้าในตะกร้า
    Wait Until Element Is Visible    locator=${ICON_MINI_BASKET}
    Element Should Contain    locator=${ICON_MINI_BASKET}    expected=${expected_result_basket}
    [Return]    ${expected_result_basket}
    Capture Page Screenshot


Click payment button
    Wait Until Element Is Visible    locator=${BTN_PAYMENT}
    Click Element    locator=${BTN_PAYMENT}


Input mobile phone
    [Arguments]    ${phone_no}    
    Input Text    ${INP_PHONENO}    ${phone_no}
    

Search store code
    [Arguments]    ${store_code}
    #กดเลือกสาขา เซเว่นอีเลฟเว่น (7-11)
    Wait Until Element Is Visible    locator=${BTN_SEARCH_BY_STORE}
    Click Element    locator=${BTN_SEARCH_BY_STORE}
    #กรุณาระบุรหัสร้าน
    # Click Element    ${INP_BRANCH_CODE} 
    Wait Until Element Is Visible    ${INP_BRANCH_CODE}  
    Input Text    ${INP_BRANCH_CODE}    ${store_code}   
    Click Element    locator=${BTN_CONFIRM_STORE_CODE}  
    Capture Page Screenshot


Verify detail shipping and pick up in store
    [Arguments]    ${detail_shipping}    ${phone_no}    ${store_code}
    Wait Until Page Contains    ${detail_shipping}
    Input mobile phone    ${phone_no}
    Search store code    ${store_code}  
    #ตรวจสอบสาขาที่ท่านเลือก
    # Wait Until Page Contains    สาขาที่ท่านเลือก  
    Wait Until Element Is Visible    locator=${LABEL_STORE_YOU_CHOOSE}
    ${get_store_detail}=    Get Text    xpath=//*[@id="store"]//span[@class="address-7_11_store-detail-header" and contains(text(),"${store_code}")]
    Element Should Contain    xpath=//*[@id="store"]//span[@class="address-7_11_store-detail-header" and contains(text(),"${store_code}")]    expected=${store_code}
    [Return]    ${store_code}
    Capture Page Screenshot


Click continue to payment button
    Click Button    locator=${BTN_CONT_PAYMENT}    
    Capture Page Screenshot

Select payment option
    Wait Until Element Is Visible    locator=${BTN_DEBIT}
    Click Element    locator=${BTN_DEBIT}


Verify payment method
    Wait Until Page Contains    วิธีการชำระเงิน
    Select payment option
    Capture Page Screenshot


Summary order
    [Arguments]    ${product_qty}    ${customer_name}    ${store_code}
    #ตรวจสอบจำนวนสินค้า
    Wait Until Element Is Visible    ${LABEL_ORDER_SUCCESS}    #//*[@id="stepModel"]//div[@class="col-xs-12 col-sm-6 basket"]/div[contains(.,"${product_qty}")] 
    ${get_product_qty}=    Get Text    ${LABEL_ORDER_SUCCESS}    #//*[@id="stepModel"]//div[@class="col-xs-12 col-sm-6 basket"]/div[contains(.,"${product_qty}")] 
    Log To Console    สรุปรายการสั่งซื้อ: "${get_product_qty}"
    Element Should Contain    locator=${LABEL_ORDER_SUCCESS}    expected=${product_qty}    #//*[@id="stepModel"]//div[@class="col-xs-12 col-sm-6 basket"]/div[contains(.,"${product_qty}")]     expected=${product_qty}

    #ตรวจสอบชื่อลูกค้า 
    Wait Until Element Is Visible    ${LABEL_ORDER_SUCCESS_CUSTOMER_NAME}    #//*[@id="stepModel"]//div[@class="invoice-address-wrapper"]/p[contains(text(),"${customer_name}")]
    ${get_customer_name}=    Get Text    ${LABEL_ORDER_SUCCESS_CUSTOMER_NAME}    #//*[@id="stepModel"]//div[@class="invoice-address-wrapper"]/p[contains(text(),"${customer_name}")]
    Log To Console    ชื่อผู้สั่งซื้อ: "${get_customer_name}"
    Should Be Equal    ${get_customer_name}    ${customer_name}

    #ตรวจสอบรายละเอียดการจัดส่ง / รับที่ร้าน
    Wait Until Page Contains    ${store_code}
    ${get_store_code}=    Get Text    ${LABEL_ORDER_SUCCESS_STORE_NAME}    #//*[@id="stepModel"]//span[@class="address-7_11_store-detail-header" and contains(.,"${store_code}")]
    Log To Console    รหัสร้านสาขา: "${store_code}"
    Element Should Contain    locator=${LABEL_ORDER_SUCCESS_STORE_NAME}    expected=${store_code}    #//*[@id="stepModel"]//span[@class="address-7_11_store-detail-header" and contains(.,"${store_code}")]    expected=${store_code}

    #ตรวจสอบราคาสินค้า
    Wait Until Page Contains    ราคา
    ${get_price}=    Get Text    locator=${LABEL_ORDER_SUCCESS_PRICE}
    Log To Console    ราคาสินค้า: "${get_price}"





    
