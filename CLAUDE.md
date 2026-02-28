# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projeto

CollabDash é uma plataforma de gerenciamento de projetos colaborativa multi-tenant. Veja [`docs/project_idea.md`](docs/project_idea.md) para a descrição completa das funcionalidades planejadas.

## Metodologia: TDD + XP

Este projeto é desenvolvido com **Test-Driven Development (TDD)** e práticas de **Extreme Programming (XP)**:

- **Red → Green → Refactor**: escreva o teste que falha primeiro, depois implemente o mínimo para passá-lo, depois refatore.
- **Testes antes do código**: nenhuma lógica de negócio ou controller deve ser escrita sem um teste correspondente escrito antes.
- **Testes de integração/sistema** para fluxos críticos (autenticação, multi-tenancy, Turbo Streams).
- **Small releases**: funcionalidades entregues em incrementos pequenos e funcionais.
- **Refactoring contínuo**: ao completar um ciclo Red/Green, revise o código para eliminar duplicação e melhorar clareza antes de avançar.
- **YAGNI**: não implemente nada além do que o teste atual exige.
- **Escopo estrito**: implemente **somente** o que foi pedido pelo usuário. Não adicione, estilize ou modifique funcionalidades, views ou arquivos que não foram explicitamente solicitados — mesmo que pareçam relacionados.

O projeto usa **RSpec** (não Minitest) como framework de testes, alinhado com a prática de BDD/XP:

| Ferramenta | Papel |
|---|---|
| **RSpec** | Framework principal — foco em comportamento |
| **FactoryBot** | Criação de dados de teste (substitui fixtures) |
| **Shoulda Matchers** | Atalhos para testar validações e associações |
| **Capybara** | Testes de sistema (simula interações do usuário no browser) |

```bash
bundle exec rspec                        # Roda todos os testes
bundle exec rspec spec/path/to/spec.rb   # Roda um arquivo específico
bundle exec rspec spec/path/to/spec.rb:LINE  # Roda um exemplo específico
```

## Stack

- **Ruby 3.4.8** / **Rails 8.1.2**
- **PostgreSQL** — primary database; production uses separate DBs for cache, queue, and cable
- **Propshaft** — asset pipeline (replaces Sprockets)
- **Importmap** — JavaScript modules (no Node.js/bundler required)
- **Hotwire** — Turbo + Stimulus for frontend interactivity
- **Tailwind CSS** — utility-first CSS (via tailwindcss-rails)
- **Solid Cache / Queue / Cable** — database-backed Rails infrastructure services

## Common Commands

```bash
bin/dev                      # Start dev server (Rails + Tailwind watcher via Procfile.dev)
bin/rails test               # Run all tests
bin/rails test test/path/to/test.rb        # Run a specific test file
bin/rails test test/path/to/test.rb:LINE   # Run a single test by line number
bin/rails test:system        # Run system tests (Capybara + Selenium)
bin/rubocop                  # Lint
bin/rubocop -a               # Auto-fix lint issues
bin/brakeman --no-pager      # Static security scan (Ruby)
bin/bundler-audit            # Gem vulnerability scan
bin/importmap audit          # JS dependency scan
bin/rails db:create db:migrate  # Initial DB setup
bin/rails db:migrate         # Run pending migrations
```

## Architecture

### Frontend

JavaScript lives in `app/javascript/`. Stimulus controllers go in `app/javascript/controllers/` and are auto-loaded via `index.js`. Import mappings are configured in `config/importmap.rb`. There is no Node.js build step — Propshaft serves assets directly.

Tailwind CSS is compiled on-the-fly in development via the `css` process in `Procfile.dev`. Custom Tailwind config belongs in `app/assets/tailwind/`.

### Database

Production uses four separate PostgreSQL databases:
- `collab_dash_production` — primary app data
- `collab_dash_production_cache` — Solid Cache (`db/cache_migrate/`)
- `collab_dash_production_queue` — Solid Queue (`db/queue_migrate/`)
- `collab_dash_production_cable` — Solid Cable (`db/cable_migrate/`)

Development and test each use a single DB (`collab_dash_development`, `collab_dash_test`).

### CI

GitHub Actions (`.github/workflows/ci.yml`) runs four jobs on PRs and pushes to `main`:
1. `scan_ruby` — Brakeman + bundler-audit
2. `scan_js` — importmap audit
3. `lint` — RuboCop (rubocop-rails-omakase style)
4. `test` — Minitest against a Postgres service container

### Deployment

Deployed via **Kamal** (config in `.kamal/`) with the production Dockerfile. The Dockerfile is production-only; it uses Thruster in front of Puma and runs as a non-root `rails` user.
