*** Settings ***
Documentation       Login pela interface do ServeRest Front.
...                 A massa de dados é criada e removida pela API, deixando o teste
...                 de interface focado só no comportamento da tela.

Resource            ../../resources/web/pages/login_page.resource
Resource            ../../resources/web/pages/home_page.resource

Suite Setup         Iniciar Teste Web
Suite Teardown      Fechar Navegador

Test Tags           web    login


*** Test Cases ***
Administrador faz login e acessa a área administrativa
    [Tags]    smoke
    ${admin}    Cadastrar Usuario Valido    administrador=true
    Fazer Login Pela Interface    ${admin}[email]    ${admin}[password]
    Conferir Que Esta Na Home Do Administrador    ${admin}[nome]
    [Teardown]    Finalizar Teste Com Logout    ${admin}

Cliente faz login e acessa a loja
    [Tags]    smoke
    ${cliente}    Cadastrar Usuario Valido    administrador=false
    Fazer Login Pela Interface    ${cliente}[email]    ${cliente}[password]
    Conferir Que Esta Na Loja Do Cliente
    [Teardown]    Finalizar Teste Com Logout    ${cliente}

Login com senha incorreta exibe mensagem de erro
    [Tags]    negativo
    ${cliente}    Cadastrar Usuario Valido    administrador=false
    Fazer Login Pela Interface    ${cliente}[email]    senha-incorreta
    Conferir Alerta De Erro    Email e/ou senha inválidos
    Location Should Contain    /login
    [Teardown]    Excluir Usuario    ${cliente}[_id]

Logout retorna para a tela de login
    ${cliente}    Cadastrar Usuario Valido    administrador=false
    Fazer Login Pela Interface    ${cliente}[email]    ${cliente}[password]
    Conferir Que Esta Na Loja Do Cliente
    Fazer Logout
    Conferir Que Esta Na Tela De Login
    [Teardown]    Excluir Usuario    ${cliente}[_id]


*** Keywords ***
Finalizar Teste Com Logout
    [Arguments]    ${usuario}
    Run Keyword And Ignore Error    Fazer Logout
    Excluir Usuario    ${usuario}[_id]
