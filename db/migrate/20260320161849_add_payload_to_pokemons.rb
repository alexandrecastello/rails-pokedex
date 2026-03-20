class AddPayloadToPokemons < ActiveRecord::Migration[7.1]
  def change
    add_column :pokemons, :payload, :jsonb
  end
end
