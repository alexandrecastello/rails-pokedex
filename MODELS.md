# Modelos e Testes - Pokédex Rails

Documentação dos modelos da aplicação e seus testes RSpec.

## Modelos Criados

### 1. **Pokemon** (`app/models/pokemon.rb`)
Representa um Pokémon na Pokédex.

**Associações:**
- `has_many :pokemon_stats` - Stats do Pokémon (HP, Attack, etc.)
- `has_many :pokemon_types` - Tipos do Pokémon
- `has_many :types, through: :pokemon_types`

**Validações:**
- `national_number`: Obrigatório, único, inteiro entre 1 e 1025
- `name`: Obrigatório, único, máx 255 caracteres
- `height`: Inteiro não-negativo (opcional)
- `weight`: Inteiro não-negativo (opcional)
- `sprite_url`: URL válida (opcional)
- `flavor_text`: Máx 10.000 caracteres (opcional)
- `payload`: JSON válido (opcional)

**Escopos:**
- `by_name(name)`: Busca case-insensitive por nome
- `ordered`: Ordena por `national_number`

---

### 2. **Type** (`app/models/type.rb`)
Representa um tipo de Pokémon (Fire, Water, Grass, etc.).

**Associações:**
- `has_many :pokemon_types` - Relacionamentos entre Pokémon e tipos
- `has_many :pokemons, through: :pokemon_types`

**Validações:**
- `name`: Obrigatório, único, máx 255 caracteres

**Escopos:**
- `ordered`: Ordena por nome alfabeticamente

---

### 3. **PokemonStat** (`app/models/pokemon_stat.rb`)
Representa um stat de um Pokémon (HP, Attack, Defense, etc.).

**Associações:**
- `belongs_to :pokemon`

**Validações:**
- `name`: Obrigatório, máx 255 caracteres
- `base_value`: Obrigatório, inteiro entre 0 e 999
- `pokemon_id`: Obrigatório
- Composição única: não permite stats duplicados por Pokemon+name

**Escopos:**
- `ordered`: Ordena por nome

---

### 4. **PokemonType** (`app/models/pokemon_type.rb`)
Relacionamento entre Pokémon e seus tipos.

**Associações:**
- `belongs_to :pokemon`
- `belongs_to :type`

**Validações:**
- `pokemon_id`: Obrigatório
- `type_id`: Obrigatório
- `slot`: Obrigatório, inteiro entre 0 e 10
- Composição única: não permite tipos duplicados por Pokemon+type

**Escopos:**
- `ordered`: Ordena por slot

---

## Testes RSpec

Os testes cobrem todas as validações, associações e escopos dos modelos.

### Rodar Todos os Testes
```bash
bundle exec rspec spec/models/
```

### Rodar Testes de um Modelo Específico
```bash
bundle exec rspec spec/models/pokemon_spec.rb
bundle exec rspec spec/models/type_spec.rb
bundle exec rspec spec/models/pokemon_stat_spec.rb
bundle exec rspec spec/models/pokemon_type_spec.rb
```

### Resultados Esperados
- **76 exemplos, 0 falhas** ✓

---

## Factories (FactoryBot)

Localizadas em `spec/factories/pokemons.rb`:

```ruby
create(:pokemon)                    # Cria um Pokémon válido
create(:type)                       # Cria um tipo válido
create(:pokemon_stat)               # Cria um stat com Pokémon associado
create(:pokemon_type)               # Cria um relacionamento válido

# Com atributos customizados:
create(:pokemon, name: "Pikachu", national_number: 25)
create(:pokemon_stat, pokemon: @pika, name: "hp", base_value: 35)
```

---

## Exemplo de Uso

```ruby
# Criar um Pokémon com tipos e stats
pokemon = Pokemon.create!(
  national_number: 1,
  name: "Bulbasaur",
  height: 7,
  weight: 69,
  sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
  flavor_text: "A small reptilian creature with a bulb on its back."
)

# Adicionar tipos
grass = Type.find_or_create_by!(name: "grass")
poison = Type.find_or_create_by!(name: "poison")
pokemon.pokemon_types.create!(type: grass, slot: 1)
pokemon.pokemon_types.create!(type: poison, slot: 2)

# Adicionar stats
pokemon.pokemon_stats.create!(name: "hp", base_value: 45)
pokemon.pokemon_stats.create!(name: "attack", base_value: 49)
pokemon.pokemon_stats.create!(name: "defense", base_value: 49)

# Usar escopos
Pokemon.by_name("bulb")                    # Encontra "Bulbasaur"
Pokemon.ordered.first                      # Primeiro Pokémon (ID 1)
Type.ordered                               # Tipos em ordem alfabética
pokemon.pokemon_stats.ordered              # Stats em ordem alfabética
pokemon.pokemon_types.ordered              # Tipos em ordem de slot
```

---

## Estrutura de Diretórios

```
app/models/
  ├── application_record.rb
  ├── pokemon.rb
  ├── type.rb
  ├── pokemon_stat.rb
  ├── pokemon_type.rb

app/validators/
  └── json_validator.rb              # Validador customizado

spec/
  ├── factories/
  │   └── pokemons.rb                # Definições FactoryBot
  ├── models/
  │   ├── pokemon_spec.rb            # Testes do modelo Pokemon
  │   ├── type_spec.rb               # Testes do modelo Type
  │   ├── pokemon_stat_spec.rb       # Testes do modelo PokemonStat
  │   └── pokemon_type_spec.rb       # Testes do modelo PokemonType
  ├── rails_helper.rb                # Configuração RSpec + Shoulda
  ├── spec_helper.rb
  └── support/
      └── factory_bot.rb             # Inclusão FactoryBot
```

---

## Gemas Utilizadas

- **rspec-rails** (~> 6.1) - Framework de testes
- **factory_bot_rails** (~> 6.4) - Fixtures dinâmicas
- **shoulda-matchers** (~> 6.1) - Matchers para validações e associações

---

## Comando para Validação Rápida

```bash
bundle exec rspec spec/models/ --format progress --fail-fast
```

---

*Última atualização: 2026-03-20*
