*** Settings ***
Documentation       Keywords da rota /login.

Resource            api.resource


*** Keywords ***
Fazer Login Na API
    [Arguments]    ${email}    ${senha}    ${status_esperado}=200
    ${corpo}    Create Dictionary    email=${email}    password=${senha}
    ${resposta}    POST On Session    serverest    /login
    ...    json=${corpo}    expected_status=${status_esperado}
    RETURN    ${resposta}

Obter Token Do Usuario
    [Documentation]    Retorna o valor completo do header Authorization ("Bearer ...").
    [Arguments]    ${usuario}
    ${resposta}    Fazer Login Na API    ${usuario}[email]    ${usuario}[password]
    RETURN    ${resposta.json()}[authorization]
