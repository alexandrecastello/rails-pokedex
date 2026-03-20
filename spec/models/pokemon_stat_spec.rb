require "rails_helper"

RSpec.describe PokemonStat, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:pokemon) }
  end

  describe "validations" do
    subject { build(:pokemon_stat) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:base_value) }
    it { is_expected.to validate_presence_of(:pokemon_id) }

    context "name" do
      let(:pokemon) { create(:pokemon) }

      it "rejeita nomes vazios" do
        subject = build(:pokemon_stat, pokemon:, name: "")
        expect(subject).not_to be_valid
      end

      it "aceita nomes com até 255 caracteres" do
        subject = build(:pokemon_stat, pokemon:, name: "a" * 255)
        expect(subject).to be_valid
      end

      it "rejeita nomes com mais de 255 caracteres" do
        subject = build(:pokemon_stat, pokemon:, name: "a" * 256)
        expect(subject).not_to be_valid
      end
    end

    context "base_value" do
      let(:pokemon) { create(:pokemon) }

      it "rejeita valores negativos" do
        subject.base_value = -1
        expect(subject).not_to be_valid
      end

      it "aceita 0" do
        subject = build(:pokemon_stat, pokemon:, base_value: 0)
        expect(subject).to be_valid
      end

      it "aceita valores até 999" do
        subject = build(:pokemon_stat, pokemon:, base_value: 999)
        expect(subject).to be_valid
      end

      it "rejeita valores acima de 999" do
        subject.base_value = 1000
        expect(subject).not_to be_valid
      end

      it "rejeita valores não inteiros" do
        subject.base_value = 50.5
        expect(subject).not_to be_valid
      end
    end

    context "uniqueness" do
      let(:pokemon) { create(:pokemon) }

      it "permite múltiplos stats para um Pokémon com nomes diferentes" do
        create(:pokemon_stat, pokemon:, name: "hp", base_value: 45)
        stat = build(:pokemon_stat, pokemon:, name: "attack", base_value: 49)
        expect(stat).to be_valid
      end

      it "rejeita stats duplicados para o mesmo Pokémon" do
        create(:pokemon_stat, pokemon:, name: "hp", base_value: 45)
        stat = build(:pokemon_stat, pokemon:, name: "hp", base_value: 50)
        expect(stat).not_to be_valid
        expect(stat.errors[:pokemon_id]).to be_present
      end
    end
  end

  describe "scopes" do
    let(:pokemon) { create(:pokemon) }

    before do
      create(:pokemon_stat, pokemon:, name: "speed", base_value: 80)
      create(:pokemon_stat, pokemon:, name: "attack", base_value: 75)
      create(:pokemon_stat, pokemon:, name: "hp", base_value: 45)
    end

    describe ".ordered" do
      it "ordena stats por nome" do
        expect(PokemonStat.ordered.pluck(:name)).to eq(["attack", "hp", "speed"])
      end
    end
  end

  describe "creating from factory" do
    it "cria um stat válido com factory" do
      stat = create(:pokemon_stat)
      expect(stat).to be_valid
    end

    it "salva um stat no banco" do
      expect { create(:pokemon_stat) }.to change(PokemonStat, :count).by(1)
    end
  end
end
