# frozen_string_literal: true

require "rails_helper"

RSpec.describe PokemonsHelper, type: :helper do
  describe "#type_styles" do
    it "retorna estilos para tipos conhecidos" do
      grass = helper.type_styles("grass")
      expect(grass[:bar]).to include("emerald")
      expect(grass[:chip]).to include("gradient")
    end

    it "usa fallback para tipos desconhecidos" do
      unknown = helper.type_styles("unknown_type")
      expect(unknown[:bar]).to eq("bg-slate-400")
    end
  end

  describe "#format_height_dm" do
    it "converte decímetros em metros" do
      expect(helper.format_height_dm(17)).to eq("1.7 m")
    end

    it "retorna em dash quando nil" do
      expect(helper.format_height_dm(nil)).to eq("—")
    end
  end

  describe "#format_weight_hg" do
    it "converte hectogramas em kg" do
      expect(helper.format_weight_hg(905)).to eq("90.5 kg")
    end
  end

  describe "#stat_bar_width_percent" do
    it "limita entre 0 e 100" do
      expect(helper.stat_bar_width_percent(255)).to eq(100.0)
      expect(helper.stat_bar_width_percent(0)).to eq(0.0)
    end
  end

  describe "#ordered_pokemon_stats" do
    it "ordena stats na ordem do PokeAPI" do
      pokemon = create(:pokemon)
      create(:pokemon_stat, pokemon:, name: "speed", base_value: 100)
      create(:pokemon_stat, pokemon:, name: "hp", base_value: 78)
      names = helper.ordered_pokemon_stats(pokemon).map(&:name)
      expect(names.index("hp")).to be < names.index("speed")
    end
  end
end
