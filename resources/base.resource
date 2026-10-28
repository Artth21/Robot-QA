*** Settings ***
Documentation       Configurações e variáveis compartilhadas por todas as suítes.
...                 Os valores padrão apontam para o ServeRest público e podem ser
...                 sobrescritos na linha de comando, por exemplo:
...                 robot -v BASE_URL:http://localhost:3000 tests/api

Library             Collections
Library             String


*** Variables ***
${BASE_URL}         https://serverest.dev
${FRONT_URL}        https://front.serverest.dev
${BROWSER}          chrome
${HEADLESS}         ${False}
${TIMEOUT}          15s
