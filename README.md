# Rails Pokédex — Field Journal

Uma Pokédex construída **em uma hora** com **Ruby on Rails 7.1** e **PostgreSQL**, alimentada pela [PokeAPI](https://pokeapi.co) e estilizada com um design system editorial ("The Digital Field Journal") gerado no **Google Stitch**.

## Screenshots

### Index — Listagem

<!-- Substitua pelo caminho real da imagem -->
![Pokédex Index](docs/screenshots/index.png)

### Show — Detalhe

<!-- Substitua pelo caminho real da imagem -->
![Pokémon Show](docs/screenshots/show.png)

---

## Stack

| Camada | Tecnologia |
|--------|------------|
| Linguagem | Ruby 3.4.6 |
| Framework | Rails 7.1.6 |
| Banco de dados | PostgreSQL |
| Frontend | Tailwind CSS (CDN) · Plus Jakarta Sans · Material Symbols |
| Testes | RSpec · FactoryBot · Shoulda Matchers |
| Dados | PokeAPI v2 (seed via `curl`) |
| Design | Google Stitch (MCP) |

## Modelos

```
Pokemon ──< PokemonStat
   │
   └──< PokemonType >── Type
```

| Modelo | Campos principais |
|--------|-------------------|
| **Pokemon** | `national_number`, `name`, `height`, `weight`, `sprite_url`, `flavor_text`, `payload` (jsonb) |
| **Type** | `name` |
| **PokemonStat** | `name`, `base_value` — stats base (hp, attack, defense…) |
| **PokemonType** | `slot` — join entre Pokémon e Type |

## Pré-requisitos

- Ruby 3.4+
- PostgreSQL 14+
- Bundler

## Setup

```bash
git clone https://github.com/alexandrecastello/rails-pokedex.git
cd rails-pokedex
bundle install
bin/rails db:create db:migrate

# Importar 151 Pokémon (padrão):
bin/rails db:seed

# Ou importar um número diferente (1–1025):
SEED_POKEMON_LIMIT=50 bin/rails db:seed
```

## Servidor

```bash
bin/rails s
# → http://localhost:3000/pokemons
```

## Rotas

| Método | Path | Ação |
|--------|------|------|
| GET | `/pokemons` | Lista de Pokémon ordenados por nº nacional |
| GET | `/pokemons/:id` | Ficha completa (stats, tipos, descrição) |

## Testes

```bash
bundle exec rspec
```

**88 exemplos** cobrindo modelos, validações, scopes, request specs e helpers.

```
spec/
├── factories/pokemons.rb
├── helpers/pokemons_helper_spec.rb
├── models/
│   ├── pokemon_spec.rb
│   ├── pokemon_stat_spec.rb
│   ├── pokemon_type_spec.rb
│   └── type_spec.rb
├── requests/pokemons_spec.rb
└── support/factory_bot.rb
```

## Estrutura do projeto

```
app/
├── controllers/
│   └── pokemons_controller.rb      # index + show
├── helpers/
│   └── pokemons_helper.rb          # cores por tipo, formatação de stats
├── models/
│   ├── pokemon.rb
│   ├── pokemon_stat.rb
│   ├── pokemon_type.rb
│   └── type.rb
├── validators/
│   └── json_validator.rb           # validação de campo JSONB
└── views/
    ├── layouts/pokedex.html.erb    # layout Stitch (Tailwind + tokens)
    └── pokemons/
        ├── index.html.erb          # grid de cards
        └── show.html.erb           # ficha detalhada
```

## Design (Stitch)

O visual segue o design system **"The Digital Field Journal"**, criado no [Google Stitch](https://stitch.withgoogle.com) e portado para ERB. Características:

- Tipografia editorial com Plus Jakarta Sans
- Paleta Material 3 com primary `#bc000a`
- Cards sem bordas — separação por camadas de superfície
- Barras de tipo com cores específicas por elemento (18 tipos)
- Sidebar e watermark do nº nacional

Uma **skill do Cursor** (`.cursor/skills/stitch-rails-pages/`) garante que novas páginas sempre passem pelo MCP Stitch antes da implementação.

## Licença

Este projeto é de uso educacional. Dados de Pokémon pertencem à Nintendo / The Pokémon Company e são obtidos via [PokeAPI](https://pokeapi.co) (aberta e gratuita).
