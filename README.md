# Automação de Testes com Robot Framework · ServeRest

[![Testes automatizados](https://github.com/Artth21/Robot-QA/actions/workflows/testes.yml/badge.svg)](https://github.com/Artth21/Robot-QA/actions/workflows/testes.yml)
[![Relatório](https://img.shields.io/badge/relat%C3%B3rio-GitHub%20Pages-0f6e6a)](https://artth21.github.io/Robot-QA/)

Projeto de portfólio com testes automatizados de **API** e de **interface web** para o [ServeRest](https://serverest.dev), uma loja virtual de estudo usada pela comunidade de QA. Os testes rodam a cada push e em todo dia útil no GitHub Actions, e o relatório da última execução fica publicado no GitHub Pages.

## O que é testado

| Camada | Suíte | Cenários |
| --- | --- | --- |
| API | `tests/api/usuarios.robot` | Cadastro, consulta por ID, e-mail duplicado, edição e exclusão |
| API | `tests/api/usuarios_validacoes.robot` | Validações de contrato orientadas a dados (campos em branco, e-mail inválido, perfil inválido) |
| API | `tests/api/login.robot` | Login válido com token Bearer, senha errada, e-mail inexistente |
| API | `tests/api/produtos.robot` | Cadastro por administrador, nome repetido, sem token (401), usuário comum (403), exclusão |
| Web | `tests/web/login.robot` | Login de administrador e de cliente, senha incorreta, logout |
| Web | `tests/web/cadastros.robot` | Cadastro de cliente pela tela, e-mail já usado, administrador cadastrando produto |

São 25 casos de teste ao todo: 18 de API e 7 de interface.

## Boas práticas aplicadas

- **Page Objects** nas telas: seletores e ações de cada tela ficam em `resources/web/pages`, e os testes leem como o fluxo de negócio.
- **Massa de dados dinâmica**: cada execução gera usuários e produtos únicos, então os testes não dependem de dados fixos.
- **Preparação e limpeza via API** nos testes web: o usuário é criado pela API antes do teste de tela e removido depois, o que deixa o teste de interface mais rápido e estável.
- **Teste orientado a dados** (`Test Template`) para as validações de contrato.
- **Testes negativos e de segurança**: rotas protegidas sem token e com perfil sem permissão.
- **Tags** (`smoke`, `negativo`, `seguranca`, `api`, `web`) para rodar só uma parte da suíte.
- **Integração contínua**: a API é testada contra um ServeRest local, isolado do ambiente público, e a interface roda em Chrome headless.

## Tecnologias

Robot Framework 7 · RequestsLibrary · SeleniumLibrary · Python 3.12 · GitHub Actions · GitHub Pages

## Estrutura

```
robot-serverest-qa/
├── .github/workflows/testes.yml      # pipeline de CI e publicação do relatório
├── resources/
│   ├── base.resource                 # variáveis de ambiente (URLs, navegador, timeout)
│   ├── dados.resource                # geração de massa de dados
│   ├── api/                          # keywords por rota: usuarios, login, produtos
│   └── web/
│       ├── web.resource              # abertura do navegador
│       └── pages/                    # Page Objects de cada tela
└── tests/
    ├── api/
    └── web/
```

## Como rodar na sua máquina

Pré-requisitos: Python 3.10 ou superior e Google Chrome instalado.

```bash
git clone https://github.com/Artth21/Robot-QA.git
cd Robot-QA
python -m venv .venv
source .venv/bin/activate          # no Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Rodar tudo contra o ServeRest público:

```bash
robot -d results tests
```

Outras formas úteis:

```bash
robot -d results tests/api                           # só API
robot -d results -v HEADLESS:True tests/web          # interface sem abrir a janela do navegador
robot -d results -i smoke tests                      # só os testes smoke
robot -d results -e negativo tests                   # tudo menos os negativos
```

Para testar a API em um ServeRest local (precisa de Node.js):

```bash
npx serverest@latest
robot -d results -v BASE_URL:http://localhost:3000 tests/api
```

Ao final, abra `results/report.html` no navegador para ver o relatório e `results/log.html` para o passo a passo de cada teste.

## Autor

**Arthur Pimentel** · Analista de QA
[LinkedIn](https://www.linkedin.com/in/arthur-pimentel-1b804b2b6/) · arthurpsbg2104@gmail.com
