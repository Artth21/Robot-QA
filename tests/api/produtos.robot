*** Settings ***
Documentation       Rota /produtos: regras de autorização e cadastro.
...                 Cadastro e exclusão exigem token de um usuário administrador.

Resource            ../../resources/api/produtos.resource
Resource            ../../resources/api/usuarios.resource
Resource            ../../resources/api/login.resource

Suite Setup         Preparar Usuarios E Tokens
Suite Teardown      Remover Usuarios Da Suite

Test Tags           api    produtos


*** Test Cases ***
Administrador cadastra produto com sucesso
    [Tags]    smoke
    ${produto}    Gerar Dados De Produto
    ${resposta}    Cadastrar Produto    ${produto}    ${TOKEN_ADMIN}
    Conferir Mensagem    ${resposta}    Cadastro realizado com sucesso
    Conferir Que Retornou Um Id    ${resposta}
    ${consulta}    Buscar Produto Por Id    ${resposta.json()}[_id]
    Should Be Equal    ${consulta.json()}[nome]    ${produto}[nome]
    Should Be Equal As Integers    ${consulta.json()}[preco]    ${produto}[preco]
    Should Be Equal As Integers    ${consulta.json()}[quantidade]    ${produto}[quantidade]
    [Teardown]    Excluir Produto    ${resposta.json()}[_id]    ${TOKEN_ADMIN}

Não permitir produto com nome repetido
    [Tags]    negativo
    ${produto}    Cadastrar Produto Valido    ${TOKEN_ADMIN}
    ${repetido}    Gerar Dados De Produto
    Set To Dictionary    ${repetido}    nome=${produto}[nome]
    ${resposta}    Cadastrar Produto    ${repetido}    ${TOKEN_ADMIN}    status_esperado=400
    Conferir Mensagem    ${resposta}    Já existe produto com esse nome
    [Teardown]    Excluir Produto    ${produto}[_id]    ${TOKEN_ADMIN}

Cadastro de produto sem token é recusado
    [Tags]    negativo    seguranca
    ${produto}    Gerar Dados De Produto
    ${resposta}    Cadastrar Produto    ${produto}    status_esperado=401
    Conferir Mensagem    ${resposta}
    ...    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Usuário comum não pode cadastrar produto
    [Tags]    negativo    seguranca
    ${produto}    Gerar Dados De Produto
    ${resposta}    Cadastrar Produto    ${produto}    ${TOKEN_CLIENTE}    status_esperado=403
    Conferir Mensagem    ${resposta}    Rota exclusiva para administradores

Excluir produto e confirmar que não é mais encontrado
    ${produto}    Cadastrar Produto Valido    ${TOKEN_ADMIN}
    ${resposta}    Excluir Produto    ${produto}[_id]    ${TOKEN_ADMIN}
    Conferir Mensagem    ${resposta}    Registro excluído com sucesso
    ${consulta}    Buscar Produto Por Id    ${produto}[_id]    status_esperado=400
    Conferir Mensagem    ${consulta}    Produto não encontrado


*** Keywords ***
Preparar Usuarios E Tokens
    Criar Sessao Na API
    ${admin}    Cadastrar Usuario Valido    administrador=true
    ${cliente}    Cadastrar Usuario Valido    administrador=false
    ${token_admin}    Obter Token Do Usuario    ${admin}
    ${token_cliente}    Obter Token Do Usuario    ${cliente}
    Set Suite Variable    ${ADMIN}    ${admin}
    Set Suite Variable    ${CLIENTE}    ${cliente}
    Set Suite Variable    ${TOKEN_ADMIN}    ${token_admin}
    Set Suite Variable    ${TOKEN_CLIENTE}    ${token_cliente}

Remover Usuarios Da Suite
    Excluir Usuario    ${ADMIN}[_id]
    Excluir Usuario    ${CLIENTE}[_id]
