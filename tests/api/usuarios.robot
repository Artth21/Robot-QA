*** Settings ***
Documentation       CRUD da rota /usuarios: cadastro, consulta, edição e exclusão.

Resource            ../../resources/api/usuarios.resource

Suite Setup         Criar Sessao Na API

Test Tags           api    usuarios


*** Test Cases ***
Cadastrar usuário com dados válidos
    [Tags]    smoke
    ${usuario}    Gerar Dados De Usuario
    ${resposta}    Cadastrar Usuario    ${usuario}
    Conferir Status Code    ${resposta}    201
    Conferir Mensagem    ${resposta}    Cadastro realizado com sucesso
    Conferir Que Retornou Um Id    ${resposta}
    [Teardown]    Excluir Usuario    ${resposta.json()}[_id]

Consultar usuário cadastrado pelo ID
    [Tags]    smoke
    ${usuario}    Cadastrar Usuario Valido    administrador=false
    ${resposta}    Buscar Usuario Por Id    ${usuario}[_id]
    Should Be Equal    ${resposta.json()}[nome]    ${usuario}[nome]
    Should Be Equal    ${resposta.json()}[email]    ${usuario}[email]
    Should Be Equal    ${resposta.json()}[administrador]    false
    [Teardown]    Excluir Usuario    ${usuario}[_id]

Não permitir cadastro com e-mail já utilizado
    [Tags]    negativo
    ${usuario}    Cadastrar Usuario Valido
    ${duplicado}    Gerar Dados De Usuario
    Set To Dictionary    ${duplicado}    email=${usuario}[email]
    ${resposta}    Cadastrar Usuario    ${duplicado}    status_esperado=400
    Conferir Mensagem    ${resposta}    Este email já está sendo usado
    [Teardown]    Excluir Usuario    ${usuario}[_id]

Editar nome e perfil de um usuário
    ${usuario}    Cadastrar Usuario Valido    administrador=false
    Set To Dictionary    ${usuario}    nome=Nome Editado QA    administrador=true
    ${resposta}    Editar Usuario    ${usuario}[_id]    ${usuario}
    Conferir Mensagem    ${resposta}    Registro alterado com sucesso
    ${consulta}    Buscar Usuario Por Id    ${usuario}[_id]
    Should Be Equal    ${consulta.json()}[nome]    Nome Editado QA
    Should Be Equal    ${consulta.json()}[administrador]    true
    [Teardown]    Excluir Usuario    ${usuario}[_id]

Excluir usuário e confirmar que não é mais encontrado
    [Tags]    smoke
    ${usuario}    Cadastrar Usuario Valido
    ${resposta}    Excluir Usuario    ${usuario}[_id]
    Conferir Mensagem    ${resposta}    Registro excluído com sucesso
    ${consulta}    Buscar Usuario Por Id    ${usuario}[_id]    status_esperado=400
    Conferir Mensagem    ${consulta}    Usuário não encontrado
