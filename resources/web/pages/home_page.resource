*** Settings ***
Documentation       Page Objects das telas iniciais: área administrativa (/admin/home)
...                 e loja do cliente (/home).

Resource            ../web.resource


*** Variables ***
${HOME_BOTAO_LOGOUT}                css:[data-testid="logout"]
${ADMIN_BOTAO_CADASTRAR_PRODUTOS}   css:[data-testid="cadastrarProdutos"]
${CLIENTE_CAMPO_PESQUISA}           css:[data-testid="pesquisar"]


*** Keywords ***
Conferir Que Esta Na Home Do Administrador
    [Arguments]    ${nome}
    Wait Until Location Contains    /admin/home
    Wait Until Page Contains    Bem Vindo
    Page Should Contain    ${nome}
    Element Should Be Visible    ${ADMIN_BOTAO_CADASTRAR_PRODUTOS}

Conferir Que Esta Na Loja Do Cliente
    Wait Until Location Contains    /home
    Wait Until Page Contains    Serverest Store
    Element Should Be Visible    ${CLIENTE_CAMPO_PESQUISA}

Ir Para Cadastro De Produtos
    Click Element    ${ADMIN_BOTAO_CADASTRAR_PRODUTOS}

Fazer Logout
    Click Element    ${HOME_BOTAO_LOGOUT}
