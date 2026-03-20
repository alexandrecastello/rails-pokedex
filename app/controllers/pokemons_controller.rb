class PokemonsController < ApplicationController
  layout "pokedex"

  def index
    @pokemons = Pokemon.includes(pokemon_types: :type).ordered
    @total_species = Pokemon.count
  end

  def show
    @pokemon = Pokemon.includes(pokemon_types: :type, pokemon_stats: []).find(params[:id])
  end
end
