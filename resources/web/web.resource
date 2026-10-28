*** Settings ***
Documentation       Base das keywords de interface: abertura e fechamento do navegador.
...                 As telas ficam em resources/web/pages (padrão Page Objects).

Resource            ../base.resource
Library             SeleniumLibrary    timeout=${TIMEOUT}    run_on_failure=Capture Page Screenshot
Resource            ../api/usuarios.resource
Resource            ../api/login.resource
Resource            ../api/produtos.resource


*** Keywords ***
Abrir Navegador
    IF    ${HEADLESS}
        ${opcoes}    Set Variable
        ...    add_argument("--headless=new");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--window-size=1920,1080")
    ELSE
        ${opcoes}    Set Variable    add_argument("--window-size=1920,1080")
    END
    Open Browser    ${FRONT_URL}/login    ${BROWSER}    options=${opcoes}
    Set Selenium Speed    0.1s

Fechar Navegador
    Close All Browsers

Iniciar Teste Web
    [Documentation]    Abre o navegador e uma sessão de API, usada para preparar e limpar a massa de dados.
    Criar Sessao Na API
    Abrir Navegador
