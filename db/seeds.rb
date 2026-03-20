# frozen_string_literal: true

require "json"
require "open3"

# Quantos Pokémon importar (1..1025). Ex.: SEED_POKEMON_LIMIT=50 bin/rails db:seed
LIMIT = ENV.fetch("SEED_POKEMON_LIMIT", "151").to_i.clamp(1, 1025)
BASE = "https://pokeapi.co/api/v2"
SLEEP_BETWEEN_REQUESTS = 0.05

# Usa curl para HTTPS (evita falhas de CRL/OpenSSL em alguns ambientes Ruby).
def pokeapi_get(path)
  url = "#{BASE}#{path}"
  stdout, stderr, status = Open3.capture3(
    "curl", "-fsSL", "--connect-timeout", "10", "--max-time", "30", url
  )
  raise "curl #{status.exitstatus}: #{stderr.presence || url}" unless status.success?

  JSON.parse(stdout)
end

def flavor_text_from_species(species_json)
  entries = species_json["flavor_text_entries"] || []
  entry =
    entries.find { |e| e.dig("language", "name") == "pt-BR" } ||
    entries.find { |e| e.dig("language", "name") == "en" }
  entry&.dig("flavor_text")&.gsub(/\f/, " ")&.squeeze(" ")&.strip
end

puts "Importando #{LIMIT} Pokémon da PokeAPI (pokeapi.co)..."

(1..LIMIT).each do |id|
  pokemon_json = pokeapi_get("/pokemon/#{id}/")
  species_json = pokeapi_get("/pokemon-species/#{id}/")

  flavor = flavor_text_from_species(species_json)

  pokemon = ::Pokemon.find_or_initialize_by(national_number: pokemon_json["id"])
  pokemon.assign_attributes(
    name: pokemon_json["name"],
    height: pokemon_json["height"],
    weight: pokemon_json["weight"],
    sprite_url: pokemon_json.dig("sprites", "front_default"),
    flavor_text: flavor,
    payload: pokemon_json
  )
  pokemon.save!

  pokemon.pokemon_stats.destroy_all
  pokemon.pokemon_types.destroy_all

  pokemon_json["stats"].each do |s|
    pokemon.pokemon_stats.create!(
      name: s.dig("stat", "name"),
      base_value: s["base_stat"]
    )
  end

  pokemon_json["types"].each do |t|
    type = ::Type.find_or_create_by!(name: t.dig("type", "name"))
    pokemon.pokemon_types.create!(type: type, slot: t["slot"])
  end

  print "."
  $stdout.flush
  sleep SLEEP_BETWEEN_REQUESTS
end

puts
puts "Concluído: #{::Pokemon.count} Pokémon, #{::Type.count} tipos."
