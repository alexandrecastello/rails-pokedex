# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_03_20_161849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pokemon_stats", force: :cascade do |t|
    t.bigint "pokemon_id", null: false
    t.string "name", null: false
    t.integer "base_value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_id", "name"], name: "index_pokemon_stats_on_pokemon_id_and_name", unique: true
    t.index ["pokemon_id"], name: "index_pokemon_stats_on_pokemon_id"
  end

  create_table "pokemon_types", force: :cascade do |t|
    t.bigint "pokemon_id", null: false
    t.bigint "type_id", null: false
    t.integer "slot", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_id", "type_id"], name: "index_pokemon_types_on_pokemon_id_and_type_id", unique: true
    t.index ["pokemon_id"], name: "index_pokemon_types_on_pokemon_id"
    t.index ["type_id"], name: "index_pokemon_types_on_type_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.integer "national_number", null: false
    t.string "name", null: false
    t.integer "height"
    t.integer "weight"
    t.string "sprite_url"
    t.text "flavor_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "payload"
    t.index ["name"], name: "index_pokemons_on_name"
    t.index ["national_number"], name: "index_pokemons_on_national_number", unique: true
  end

  create_table "types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_types_on_name", unique: true
  end

  add_foreign_key "pokemon_stats", "pokemons"
  add_foreign_key "pokemon_types", "pokemons"
  add_foreign_key "pokemon_types", "types"
end
