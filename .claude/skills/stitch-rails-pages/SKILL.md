---
name: stitch-rails-pages
description: Ensures new Rails views, layouts, and page-level UI in rails-pokedex are designed in Google Stitch and retrieved via MCP before coding. Use when creating ERB templates, layouts, partials, styling overhauls, or any new user-facing page; when refactoring views; or when the user mentions Stitch, UI de página, telas, or frontend Rails.
---

# Stitch + Rails (rails-pokedex)

## Objetivo

Nenhuma página nova (view ERB, layout substancial, ou fluxo de UI) deve ser inventada “do zero” sem passar pelo **MCP Stitch**: o design (HTML, tokens, hierarquia visual) vem do projeto Stitch e só depois é adaptado a Rails (ERB, helpers, `link_to`, `image_tag`, dados dinâmicos).

## Servidor MCP

- Identificador típico no Cursor: **`user-stitch`** (pasta `mcps/user-stitch/tools/`).
- **Antes de qualquer chamada**, ler o descritor JSON da ferramenta em `mcps/user-stitch/tools/<nome>.json` para parâmetros obrigatórios.

## Ferramentas Stitch a usar

| Ferramenta | Uso |
|------------|-----|
| `list_projects` | Descobrir o projeto (ex.: Pokédex) e obter `name` / id numérico. |
| `get_project` | Detalhes do projeto, `designTheme`, instâncias de ecrã. |
| `list_screens` | Listar ecrãs; argumento `projectId` **sem** prefixo `projects/`. |
| `get_screen` | Obter HTML/screenshot de um ecrã; `name` no formato `projects/{id}/screens/{screenId}`. |
| `generate_screen_from_text` | Gerar novo ecrã a partir de prompt (quando não existir ecrã adequado). |
| `edit_screens` | Ajustar ecrã existente no Stitch antes de portar para Rails. |
| `generate_variants` | Variantes de um ecrã para explorar alternativas. |
| `create_project` | Só se for necessário um projeto Stitch novo (caso raro neste repo). |

## Fluxo obrigatório (nova página ou refactor grande)

1. **Resolver `projectId`**
   - Chamar `list_projects` e localizar o projeto deste produto (título Pokédex / Field Journal / etc.), **ou**
   - Ler `.cursor/stitch.json` no repo se existir: `{ "projectId": "..." }` (só o id, sem `projects/`).

2. **Listar ecrãs**
   - `list_screens` com `projectId`.

3. **Obter referência visual**
   - Para o ecrã correspondente à página: `get_screen` com `name` completo retornado em `list_screens`.
   - Se não houver ecrã: `generate_screen_from_text` com prompt alinhado ao pedido, depois `get_screen` no resultado.

4. **Portar para Rails**
   - Extrair estrutura, classes Tailwind/tokens e padrões do HTML Stitch.
   - Implementar em ERB com dados reais (`@model`, paths, CSRF, etc.).
   - Manter **paridade visual** com o Stitch; adaptações só por limitações de dados (campos inexistentes).

5. **Testes**
   - Respeitar `.cursorrules`: specs RSpec para comportamento alterado (request/system conforme o caso).

## O que não fazer

- Não criar layout “editorial” ou grid de cards sem consultar Stitch quando o objetivo é UI de produto neste projeto.
- Não copiar apenas uma captura: preferir **`htmlCode`** (ou download do ficheiro HTML) para classes e estrutura.
- Não assumir `projectId` fixo no texto da skill sem `list_projects` ou `.cursor/stitch.json`.

## Progressive disclosure

- Convenções de layout partilhado: documentar em `reference.md` nesta pasta se o projeto crescer.
- Detalhes da API Stitch: consultar descritores em `mcps/user-stitch/tools/`.

## Checklist rápido

- [ ] `projectId` confirmado (lista ou `.cursor/stitch.json`)
- [ ] Ecrã alvo listado e obtido via `get_screen` (ou gerado + obtido)
- [ ] View ERB alinhada ao HTML/tokens do Stitch
- [ ] `bundle exec rspec` verde após mudanças de comportamento
