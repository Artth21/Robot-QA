*** Settings ***
Documentation       Page Object da tela pública de cadastro de usuário (/cadastrarusuarios).

Resource            ../web.resource


*** Variables ***
${CADASTRO_CAMPO_NOME}          css:[data-testid="nome"]
${CADASTRO_CAMPO_EMAIL}         css:[data-testid="email"]
${CADASTRO_CAMPO_SENHA}         css:[data-testid="password"]
${CADASTRO_CHECK_ADMIN}         css:[data-testid="checkbox"]
${CADASTRO_BOTAO_CADASTRAR}     css:[data-testid="cadastrar"]


*** Keywords ***
Conferir Que Esta Na Tela De Cadastro
    Wait Until Location Contains    /cadastrarusuarios
    Wait Until Element Is Visible    ${CADASTRO_CAMPO_NOME}

Preencher Cadastro De Usuario
    [Arguments]    ${usuario}
    Input Text    ${CADASTRO_CAMPO_NOME}    ${usuario}[nome]
    Input Text    ${CADASTRO_CAMPO_EMAIL}    ${usuario}[email]
    Input Password    ${CADASTRO_CAMPO_SENHA}    ${usuario}[password]
    IF    "${usuario}[administrador]" == "true"
        Select Checkbox    ${CADASTRO_CHECK_ADMIN}
    END

Clicar Em Cadastrar
    Click Element    ${CADASTRO_BOTAO_CADASTRAR}
