class PokemonType < ApplicationRecord
  belongs_to :pokemon
  belongs_to :type

  validates :pokemon_id, presence: true
  validates :type_id, presence: true
  validates :slot, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :pokemon_id, uniqueness: { scope: :type_id, message: "com esse tipo já existe para este Pokémon" }

  scope :ordered, -> { order(:slot) }
end
