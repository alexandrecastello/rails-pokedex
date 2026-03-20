FactoryBot.define do
  factory :pokemon do
    sequence(:national_number) { |n| n }
    sequence(:name) { |n| "pokemon_#{n}" }
    height { 10 }
    weight { 100 }
    sprite_url { "https://example.com/sprite.png" }
    flavor_text { "A sample Pokémon." }
    payload { {} }
  end

  factory :type do
    sequence(:name) { |n| "type_#{n}" }
  end

  factory :pokemon_stat do
    pokemon
    name { "hp" }
    base_value { 45 }
  end

  factory :pokemon_type do
    pokemon
    type
    slot { 1 }
  end
end
