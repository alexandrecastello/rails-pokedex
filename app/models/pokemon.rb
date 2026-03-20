class Pokemon < ApplicationRecord
  has_many :pokemon_stats, dependent: :destroy
  has_many :pokemon_types, dependent: :destroy
  has_many :types, through: :pokemon_types

  validates :national_number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 1025 }
  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 255 }
  validates :height, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :weight, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :sprite_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "deve ser uma URL válida" }, allow_nil: true, allow_blank: true
  validates :flavor_text, length: { maximum: 10_000 }, allow_nil: true, allow_blank: true
  # validates :payload, json: true, allow_nil: true

  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
  scope :ordered, -> { order(:national_number) }
end
