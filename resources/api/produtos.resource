*** Settings ***
Documentation       Keywords da rota /produtos (cadastro, edição e exclusão exigem administrador).

Resource            api.resource


*** Keywords ***
Cadastrar Produto
    [Arguments]    ${produto}    ${token}=${EMPTY}    ${status_esperado}=201
    ${headers}    Montar Cabecalho De Autorizacao    ${token}
    ${resposta}    POST On Session    serverest    /produtos
    ...    json=${produto}    headers=${headers}    expected_status=${status_esperado}
    RETURN    ${resposta}

Cadastrar Produto Valido
    [Arguments]    ${token}
    ${produto}    Gerar Dados De Produto
    ${resposta}    Cadastrar Produto    ${produto}    ${token}
    Set To Dictionary    ${produto}    _id=${resposta.json()}[_id]
    RETURN    ${produto}

Buscar Produto Por Id
    [Arguments]    ${id}    ${status_esperado}=200
    ${resposta}    GET On Session    serverest    /produtos/${id}
    ...    expected_status=${status_esperado}
    RETURN    ${resposta}

Buscar Produto Por Nome
    [Arguments]    ${nome}
    ${params}    Create Dictionary    nome=${nome}
    ${resposta}    GET On Session    serverest    /produtos    params=${params}
    RETURN    ${resposta}

Excluir Produto
    [Arguments]    ${id}    ${token}
    ${headers}    Montar Cabecalho De Autorizacao    ${token}
    ${resposta}    DELETE On Session    serverest    /produtos/${id}
    ...    headers=${headers}    expected_status=200
    RETURN    ${resposta}

Excluir Produto Pelo Nome
    [Arguments]    ${nome}    ${token}
    ${resposta}    Buscar Produto Por Nome    ${nome}
    FOR    ${produto}    IN    @{resposta.json()}[produtos]
        Excluir Produto    ${produto}[_id]    ${token}
    END
