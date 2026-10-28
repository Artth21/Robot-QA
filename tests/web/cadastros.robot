*** Settings ***
Documentation       Fluxos de cadastro pela interface: novo usuário e novo produto.

Resource            ../../resources/web/pages/login_page.resource
Resource            ../../resources/web/pages/cadastro_usuario_page.resource
Resource            ../../resources/web/pages/home_page.resource
Resource            ../../resources/web/pages/cadastro_produto_page.resource

Suite Setup         Iniciar Teste Web
Suite Teardown      Fechar Navegador

Test Tags           web    cadastro


*** Test Cases ***
Visitante se cadastra como cliente e é levado à loja
    [Tags]    smoke
    ${usuario}    Gerar Dados De Usuario    administrador=false
    Acessar Tela De Login
    Ir Para Cadastro De Usuario
    Conferir Que Esta Na Tela De Cadastro
    Preencher Cadastro De Usuario    ${usuario}
    Clicar Em Cadastrar
    Wait Until Page Contains    Cadastro realizado com sucesso
    Conferir Que Esta Na Loja Do Cliente
    [Teardown]    Limpar Usuario Criado Pela Interface    ${usuario}[email]

Cadastro com e-mail já utilizado exibe mensagem de erro
    [Tags]    negativo
    ${existente}    Cadastrar Usuario Valido    administrador=false
    ${usuario}    Gerar Dados De Usuario    administrador=false
    Set To Dictionary    ${usuario}    email=${existente}[email]
    Acessar Tela De Login
    Ir Para Cadastro De Usuario
    Preencher Cadastro De Usuario    ${usuario}
    Clicar Em Cadastrar
    Wait Until Page Contains    Este email já está sendo usado
    Location Should Contain    /cadastrarusuarios
    [Teardown]    Excluir Usuario    ${existente}[_id]

Administrador cadastra produto e o vê na listagem
    [Tags]    smoke
    ${admin}    Cadastrar Usuario Valido    administrador=true
    ${token}    Obter Token Do Usuario    ${admin}
    ${produto}    Gerar Dados De Produto
    Fazer Login Pela Interface    ${admin}[email]    ${admin}[password]
    Conferir Que Esta Na Home Do Administrador    ${admin}[nome]
    Ir Para Cadastro De Produtos
    Conferir Que Esta Na Tela De Cadastro De Produtos
    Preencher Cadastro De Produto    ${produto}
    Clicar Em Cadastrar Produto
    Conferir Produto Na Listagem    ${produto}[nome]
    [Teardown]    Limpar Produto E Administrador    ${produto}[nome]    ${token}    ${admin}


*** Keywords ***
Limpar Usuario Criado Pela Interface
    [Arguments]    ${email}
    Run Keyword And Ignore Error    Fazer Logout
    Excluir Usuario Pelo Email    ${email}

Limpar Produto E Administrador
    [Arguments]    ${nome_produto}    ${token}    ${admin}
    Run Keyword And Ignore Error    Fazer Logout
    Excluir Produto Pelo Nome    ${nome_produto}    ${token}
    Excluir Usuario    ${admin}[_id]
