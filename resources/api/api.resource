*** Settings ***
Documentation       Base das keywords de API: sessão HTTP e validações comuns.

Library             RequestsLibrary
Resource            ../base.resource
Resource            ../dados.resource


*** Keywords ***
Criar Sessao Na API
    Create Session    serverest    ${BASE_URL}    disable_warnings=1

Montar Cabecalho De Autorizacao
    [Documentation]    Sem token, retorna cabeçalho vazio para testar rotas protegidas.
    [Arguments]    ${token}=${EMPTY}
    IF    "${token}" == "${EMPTY}"
        ${headers}    Create Dictionary
    ELSE
        ${headers}    Create Dictionary    Authorization=${token}
    END
    RETURN    ${headers}

Conferir Status Code
    [Arguments]    ${resposta}    ${status_esperado}
    Should Be Equal As Integers    ${resposta.status_code}    ${status_esperado}

Conferir Mensagem
    [Arguments]    ${resposta}    ${mensagem_esperada}
    Should Be Equal As Strings    ${resposta.json()}[message]    ${mensagem_esperada}

Conferir Que Retornou Um Id
    [Arguments]    ${resposta}
    Dictionary Should Contain Key    ${resposta.json()}    _id
    Should Match Regexp    ${resposta.json()}[_id]    ^[a-zA-Z0-9]{16}$
