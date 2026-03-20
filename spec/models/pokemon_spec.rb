require "rails_helper"

RSpec.describe Pokemon, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:pokemon_stats).dependent(:destroy) }
    it { is_expected.to have_many(:pokemon_types).dependent(:destroy) }
    it { is_expected.to have_many(:types).through(:pokemon_types) }
  end

  describe "validations" do
    subject { build(:pokemon) }

    it { is_expected.to validate_presence_of(:national_number) }
    it { is_expected.to validate_uniqueness_of(:national_number) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    context "national_number" do
      it "rejeita valores negativos" do
        subject.national_number = -1
        expect(subject).not_to be_valid
        expect(subject.errors[:national_number]).to include(/greater than 0/)
      end

      it "rejeita valores acima de 1025" do
        subject.national_number = 1026
        expect(subject).not_to be_valid
        expect(subject.errors[:national_number]).to include(/less than or equal to 1025/)
      end

      it "aceita valores entre 1 e 1025" do
        subject.national_number = 500
        expect(subject).to be_valid
      end
    end

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

    context "height" do
      it "rejeita valores negativos" do
        subject.height = -1
        expect(subject).not_to be_valid
      end

      it "aceita valores positivos" do
        subject.height = 10
        expect(subject).to be_valid
      end

      it "aceita nil" do
        subject.height = nil
        expect(subject).to be_valid
      end
    end

    context "weight" do
      it "rejeita valores negativos" do
        subject.weight = -1
        expect(subject).not_to be_valid
      end

      it "aceita valores positivos" do
        subject.weight = 100
        expect(subject).to be_valid
      end

      it "aceita nil" do
        subject.weight = nil
        expect(subject).to be_valid
      end
    end

    context "sprite_url" do
      it "aceita URLs válidas" do
        subject.sprite_url = "https://example.com/sprite.png"
        expect(subject).to be_valid
      end

      it "rejeita URLs inválidas" do
        subject.sprite_url = "not a url"
        expect(subject).not_to be_valid
      end

      it "aceita nil" do
        subject.sprite_url = nil
        expect(subject).to be_valid
      end
    end

    context "flavor_text" do
      it "aceita textos longos" do
        subject.flavor_text = "a" * 10_000
        expect(subject).to be_valid
      end

      it "rejeita textos com mais de 10.000 caracteres" do
        subject.flavor_text = "a" * 10_001
        expect(subject).not_to be_valid
      end

      it "aceita nil" do
        subject.flavor_text = nil
        expect(subject).to be_valid
      end
    end
  end

  describe "scopes" do
    before do
      create(:pokemon, name: "Pikachu")
      create(:pokemon, name: "Raichu")
      create(:pokemon, name: "Charizard")
    end

    describe ".by_name" do
      it "encontra Pokémon por nome (case-insensitive)" do
        expect(Pokemon.by_name("pikachu")).to include(Pokemon.find_by(name: "Pikachu"))
      end

      it "encontra parcialmente" do
        expect(Pokemon.by_name("rai")).to include(Pokemon.find_by(name: "Raichu"))
      end
    end

    describe ".ordered" do
      it "ordena por national_number" do
        expect(Pokemon.ordered.pluck(:national_number)).to eq(Pokemon.ordered.pluck(:national_number).sort)
      end
    end
  end

  describe "instance methods" do
    let(:pokemon) { create(:pokemon) }

    it "pode ter múltiplos stats" do
      create(:pokemon_stat, pokemon:, name: "hp", base_value: 45)
      create(:pokemon_stat, pokemon:, name: "attack", base_value: 49)
      expect(pokemon.pokemon_stats.count).to eq(2)
    end

    it "pode ter múltiplos tipos" do
      type1 = create(:type)
      type2 = create(:type)
      create(:pokemon_type, pokemon:, type: type1, slot: 1)
      create(:pokemon_type, pokemon:, type: type2, slot: 2)
      expect(pokemon.types.count).to eq(2)
    end
  end

  describe "creating from factory" do
    it "cria um Pokémon válido com factory" do
      pokemon = build(:pokemon)
      expect(pokemon).to be_valid
    end

    it "salva um Pokémon no banco" do
      expect { create(:pokemon) }.to change(Pokemon, :count).by(1)
    end
  end
end
