*** Settings ***
Documentation       Page Object da tela de cadastro de produtos do administrador
...                 (/admin/cadastrarprodutos).

Resource            ../web.resource


*** Variables ***
${PRODUTO_CAMPO_NOME}           css:[data-testid="nome"]
${PRODUTO_CAMPO_PRECO}          css:[data-testid="preco"]
${PRODUTO_CAMPO_DESCRICAO}      css:[data-testid="descricao"]
${PRODUTO_CAMPO_QUANTIDADE}     css:[data-testid="quantity"]
# O seletor abaixo tem um erro de digitação na própria aplicação ("cadastar").
${PRODUTO_BOTAO_CADASTRAR}      css:[data-testid="cadastarProdutos"]


*** Keywords ***
Conferir Que Esta Na Tela De Cadastro De Produtos
    Wait Until Location Contains    /admin/cadastrarprodutos
    Wait Until Element Is Visible    ${PRODUTO_CAMPO_NOME}

Preencher Cadastro De Produto
    [Arguments]    ${produto}
    Input Text    ${PRODUTO_CAMPO_NOME}    ${produto}[nome]
    Input Text    ${PRODUTO_CAMPO_PRECO}    ${produto}[preco]
    Input Text    ${PRODUTO_CAMPO_DESCRICAO}    ${produto}[descricao]
    Input Text    ${PRODUTO_CAMPO_QUANTIDADE}    ${produto}[quantidade]

Clicar Em Cadastrar Produto
    Click Element    ${PRODUTO_BOTAO_CADASTRAR}

Conferir Produto Na Listagem
    [Arguments]    ${nome}
    Wait Until Location Contains    /admin/listarprodutos
    Wait Until Page Contains    ${nome}    timeout=30s
