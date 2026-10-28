*** Settings ***
Documentation       Keywords da rota /usuarios.

Resource            api.resource


*** Keywords ***
Cadastrar Usuario
    [Arguments]    ${usuario}    ${status_esperado}=201
    ${resposta}    POST On Session    serverest    /usuarios
    ...    json=${usuario}    expected_status=${status_esperado}
    RETURN    ${resposta}

Cadastrar Usuario Valido
    [Documentation]    Cria um usuário novo e devolve seus dados já com o ``_id``.
    [Arguments]    ${administrador}=true
    ${usuario}    Gerar Dados De Usuario    ${administrador}
    ${resposta}    Cadastrar Usuario    ${usuario}
    Set To Dictionary    ${usuario}    _id=${resposta.json()}[_id]
    RETURN    ${usuario}

Buscar Usuario Por Id
    [Arguments]    ${id}    ${status_esperado}=200
    ${resposta}    GET On Session    serverest    /usuarios/${id}
    ...    expected_status=${status_esperado}
    RETURN    ${resposta}

Buscar Usuario Por Email
    [Arguments]    ${email}
    ${params}    Create Dictionary    email=${email}
    ${resposta}    GET On Session    serverest    /usuarios    params=${params}
    RETURN    ${resposta}

Editar Usuario
    [Arguments]    ${id}    ${usuario}    ${status_esperado}=200
    ${corpo}    Copy Dictionary    ${usuario}
    Remove From Dictionary    ${corpo}    _id
    ${resposta}    PUT On Session    serverest    /usuarios/${id}
    ...    json=${corpo}    expected_status=${status_esperado}
    RETURN    ${resposta}

Excluir Usuario
    [Arguments]    ${id}
    ${resposta}    DELETE On Session    serverest    /usuarios/${id}    expected_status=200
    RETURN    ${resposta}

Excluir Usuario Pelo Email
    [Documentation]    Limpeza de usuários criados pela interface, quando só sabemos o e-mail.
    [Arguments]    ${email}
    ${resposta}    Buscar Usuario Por Email    ${email}
    FOR    ${usuario}    IN    @{resposta.json()}[usuarios]
        Excluir Usuario    ${usuario}[_id]
    END
