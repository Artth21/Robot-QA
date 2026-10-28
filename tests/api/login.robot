*** Settings ***
Documentation       Autenticação na rota /login.

Resource            ../../resources/api/login.resource
Resource            ../../resources/api/usuarios.resource

Suite Setup         Preparar Usuario Para Login
Suite Teardown      Excluir Usuario    ${USUARIO}[_id]

Test Tags           api    login


*** Test Cases ***
Login com credenciais válidas retorna token Bearer
    [Tags]    smoke
    ${resposta}    Fazer Login Na API    ${USUARIO}[email]    ${USUARIO}[password]
    Conferir Mensagem    ${resposta}    Login realizado com sucesso
    Should Match Regexp    ${resposta.json()}[authorization]    ^Bearer \\S+$

Login com senha incorreta é recusado
    [Tags]    negativo
    ${resposta}    Fazer Login Na API    ${USUARIO}[email]    senha-errada    status_esperado=401
    Conferir Mensagem    ${resposta}    Email e/ou senha inválidos

Login com e-mail não cadastrado é recusado
    [Tags]    negativo
    ${resposta}    Fazer Login Na API    nao.existe@portfolio.dev    ${USUARIO}[password]    status_esperado=401
    Conferir Mensagem    ${resposta}    Email e/ou senha inválidos


*** Keywords ***
Preparar Usuario Para Login
    Criar Sessao Na API
    ${usuario}    Cadastrar Usuario Valido
    Set Suite Variable    ${USUARIO}    ${usuario}
