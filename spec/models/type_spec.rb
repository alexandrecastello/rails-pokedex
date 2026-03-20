require "rails_helper"

RSpec.describe Type, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:pokemon_types).dependent(:destroy) }
    it { is_expected.to have_many(:pokemons).through(:pokemon_types) }
  end

  describe "validations" do
    subject { build(:type) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    context "name" do
      it "rejeita nomes vazios" do
        subject.name = ""
        expect(subject).not_to be_valid
      end

      it "aceita nomes com até 255 caracteres" do
        subject.name = "a" * 255
        expect(subject).to be_valid
      end

      it "rejeita nomes com mais de 255 caracteres" do
        subject.name = "a" * 256
        expect(subject).not_to be_valid
      end
    end
  end

  describe "scopes" do
    before do
      create(:type, name: "Fire")
      create(:type, name: "Water")
      create(:type, name: "Grass")
    end

    describe ".ordered" do
      it "ordena tipos por nome alfabeticamente" do
        expect(Type.ordered.pluck(:name)).to eq(["Fire", "Grass", "Water"])
      end
    end
  end

  describe "instance methods" do
    let(:type) { create(:type) }

    it "pode ter múltiplos Pokémon" do
      create(:pokemon_type, type:)
      create(:pokemon_type, type:)
      expect(type.pokemons.count).to eq(2)
    end
  end

  describe "creating from factory" do
    it "cria um tipo válido com factory" do
      type = build(:type)
      expect(type).to be_valid
    end

    it "salva um tipo no banco" do
      expect { create(:type) }.to change(Type, :count).by(1)
    end
  end
end
