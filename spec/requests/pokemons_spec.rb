require "rails_helper"

RSpec.describe "Pokemons", type: :request do
  describe "GET /pokemons" do
    it "responde com sucesso" do
      get pokemons_path
      expect(response).to have_http_status(:ok)
    end

    it "lista os Pokémon ordenados por número nacional" do
      create(:pokemon, national_number: 3, name: "Venusaur")
      create(:pokemon, national_number: 1, name: "Bulbasaur")
      create(:pokemon, national_number: 2, name: "Ivysaur")

      get pokemons_path

      expect(response.body).to include("Bulbasaur")
      expect(response.body).to include("Ivysaur")
      expect(response.body).to include("Venusaur")

      positions = [
        response.body.index("Bulbasaur"),
        response.body.index("Ivysaur"),
        response.body.index("Venusaur")
      ]
      expect(positions).to eq(positions.sort)
    end

    context "quando não há Pokémon" do
      it "mostra mensagem apropriada" do
        get pokemons_path
        expect(response.body).to include("Nenhum Pokémon cadastrado ainda.")
      end
    end
  end

  describe "GET /pokemons/:id" do
    let(:pokemon) { create(:pokemon, name: "Pikachu", national_number: 25) }

    it "responde com sucesso" do
      get pokemon_path(pokemon)
      expect(response).to have_http_status(:ok)
    end

    it "exibe o Pokémon" do
      get pokemon_path(pokemon)
      expect(response.body).to include("Pikachu")
      expect(response.body).to include("#025")
    end
  end
end
