class PokemonStat < ApplicationRecord
  belongs_to :pokemon

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :base_value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 999 }
  validates :pokemon_id, presence: true
  validates :pokemon_id, uniqueness: { scope: :name, message: "com esse stat já existe para este Pokémon" }

  scope :ordered, -> { order(:name) }
end
