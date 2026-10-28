*** Settings ***
Documentation       Validações de contrato no cadastro de usuário (POST /usuarios).
...                 Suíte orientada a dados: cada linha é um cenário com o campo
...                 alterado, o valor enviado e a mensagem de erro esperada.

Resource            ../../resources/api/usuarios.resource

Suite Setup         Criar Sessao Na API
Test Template       Cadastro Deve Ser Recusado

Test Tags           api    usuarios    negativo


*** Test Cases ***                                  CAMPO            VALOR                MENSAGEM ESPERADA
Nome em branco                                      nome             ${EMPTY}             nome não pode ficar em branco
E-mail em branco                                    email            ${EMPTY}             email não pode ficar em branco
E-mail em formato inválido                          email            qa.portfolio.dev     email deve ser um email válido
Senha em branco                                     password         ${EMPTY}             password não pode ficar em branco
Perfil de administrador diferente de true/false    administrador    sim                  administrador deve ser 'true' ou 'false'


*** Keywords ***
Cadastro Deve Ser Recusado
    [Arguments]    ${campo}    ${valor}    ${mensagem}
    ${usuario}    Gerar Dados De Usuario
    Set To Dictionary    ${usuario}    ${campo}=${valor}
    ${resposta}    Cadastrar Usuario    ${usuario}    status_esperado=400
    Should Be Equal As Strings    ${resposta.json()}[${campo}]    ${mensagem}
