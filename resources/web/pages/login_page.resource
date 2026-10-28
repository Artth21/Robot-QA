*** Settings ***
Documentation       Page Object da tela de Login (/login).

Resource            ../web.resource


*** Variables ***
${LOGIN_CAMPO_EMAIL}        css:[data-testid="email"]
${LOGIN_CAMPO_SENHA}        css:[data-testid="senha"]
${LOGIN_BOTAO_ENTRAR}       css:[data-testid="entrar"]
${LOGIN_LINK_CADASTRO}      css:[data-testid="cadastrar"]


*** Keywords ***
Acessar Tela De Login
    Go To    ${FRONT_URL}/login
    Wait Until Element Is Visible    ${LOGIN_CAMPO_EMAIL}

Preencher Credenciais
    [Arguments]    ${email}    ${senha}
    Input Text    ${LOGIN_CAMPO_EMAIL}    ${email}
    Input Password    ${LOGIN_CAMPO_SENHA}    ${senha}

Clicar Em Entrar
    Click Element    ${LOGIN_BOTAO_ENTRAR}

Fazer Login Pela Interface
    [Arguments]    ${email}    ${senha}
    Acessar Tela De Login
    Preencher Credenciais    ${email}    ${senha}
    Clicar Em Entrar

Ir Para Cadastro De Usuario
    Click Element    ${LOGIN_LINK_CADASTRO}

Conferir Que Esta Na Tela De Login
    Wait Until Location Contains    /login
    Wait Until Element Is Visible    ${LOGIN_BOTAO_ENTRAR}

Conferir Alerta De Erro
    [Arguments]    ${mensagem}
    Wait Until Page Contains    ${mensagem}
