require "rails_helper"

RSpec.describe PokemonType, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:pokemon) }
    it { is_expected.to belong_to(:type) }
  end

  describe "validations" do
    subject { build(:pokemon_type) }

    it { is_expected.to validate_presence_of(:pokemon_id) }
    it { is_expected.to validate_presence_of(:type_id) }
    it { is_expected.to validate_presence_of(:slot) }

    context "slot" do
      it "rejeita valores negativos" do
        subject.slot = -1
        expect(subject).not_to be_valid
      end

      it "aceita 0" do
        subject = create(:pokemon_type, slot: 0)
        expect(subject).to be_valid
      end

      it "aceita valores até 10" do
        subject = create(:pokemon_type, slot: 10)
        expect(subject).to be_valid
      end

      it "rejeita valores acima de 10" do
        subject.slot = 11
        expect(subject).not_to be_valid
      end

      it "rejeita valores não inteiros" do
        subject.slot = 1.5
        expect(subject).not_to be_valid
      end
    end

    context "uniqueness" do
      let(:pokemon) { create(:pokemon) }
      let(:type) { create(:type) }

      it "rejeita tipos duplicados para o mesmo Pokémon" do
        create(:pokemon_type, pokemon:, type:, slot: 1)
        duplicate = build(:pokemon_type, pokemon:, type:, slot: 2)
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:pokemon_id]).to be_present
      end

      it "permite o mesmo tipo em Pokémon diferentes" do
        pokemon2 = create(:pokemon)
        create(:pokemon_type, pokemon:, type:, slot: 1)
        pt = build(:pokemon_type, pokemon: pokemon2, type:, slot: 1)
        expect(pt).to be_valid
      end
    end
  end

  describe "scopes" do
    let(:pokemon) { create(:pokemon) }
    let(:type1) { create(:type) }
    let(:type2) { create(:type) }
    let(:type3) { create(:type) }

    before do
      create(:pokemon_type, pokemon:, type: type1, slot: 3)
      create(:pokemon_type, pokemon:, type: type2, slot: 1)
      create(:pokemon_type, pokemon:, type: type3, slot: 2)
    end

    describe ".ordered" do
      it "ordena tipos por slot" do
        expect(PokemonType.where(pokemon:).ordered.pluck(:slot)).to eq([1, 2, 3])
      end
    end
  end

  describe "instance methods" do
    let(:pokemon) { create(:pokemon) }
    let(:type) { create(:type) }

    it "vincula corretamente Pokémon e tipo" do
      pt = create(:pokemon_type, pokemon:, type:, slot: 1)
      expect(pt.pokemon).to eq(pokemon)
      expect(pt.type).to eq(type)
    end
  end

  describe "creating from factory" do
    it "cria um tipo de Pokémon válido com factory" do
      pt = create(:pokemon_type)
      expect(pt).to be_valid
    end

    it "salva um tipo de Pokémon no banco" do
      expect { create(:pokemon_type) }.to change(PokemonType, :count).by(1)
    end
  end
end
