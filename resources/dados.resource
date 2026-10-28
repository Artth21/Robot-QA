*** Settings ***
Documentation       Geração de massa de dados única a cada execução, para que os testes
...                 não dependam de registros fixos e possam rodar em paralelo.

Resource            base.resource


*** Keywords ***
Gerar Sufixo Unico
    ${sufixo}    Generate Random String    10    [LOWER][NUMBERS]
    RETURN    ${sufixo}

Gerar Dados De Usuario
    [Documentation]    Retorna um dicionário pronto para o corpo de POST /usuarios.
    ...                ``administrador`` deve ser a string "true" ou "false", como a API exige.
    [Arguments]    ${administrador}=true
    ${sufixo}    Gerar Sufixo Unico
    ${senha}    Generate Random String    12    [LETTERS][NUMBERS]
    ${usuario}    Create Dictionary
    ...    nome=QA Portfolio ${sufixo}
    ...    email=qa.${sufixo}@portfolio.dev
    ...    password=${senha}
    ...    administrador=${administrador}
    RETURN    ${usuario}

Gerar Dados De Produto
    [Documentation]    Retorna um dicionário pronto para o corpo de POST /produtos.
    ${sufixo}    Gerar Sufixo Unico
    ${preco}    Evaluate    random.randint(10, 999)    modules=random
    ${quantidade}    Evaluate    random.randint(1, 200)    modules=random
    ${produto}    Create Dictionary
    ...    nome=Produto QA ${sufixo}
    ...    preco=${preco}
    ...    descricao=Produto criado pela automação de testes
    ...    quantidade=${quantidade}
    RETURN    ${produto}
