# frozen_string_literal: true

module PokemonsHelper
  STAT_ORDER = %w[hp attack defense special-attack special-defense speed].freeze

  TYPE_STYLES = {
    "grass" => {
      bar: "bg-emerald-500",
      badge: "bg-emerald-100 text-emerald-700",
      glow: "bg-emerald-50",
      chip: "bg-gradient-to-br from-emerald-500 to-emerald-700"
    },
    "fire" => {
      bar: "bg-orange-500",
      badge: "bg-orange-100 text-orange-700",
      glow: "bg-orange-50",
      chip: "bg-gradient-to-br from-orange-500 to-red-600"
    },
    "water" => {
      bar: "bg-blue-500",
      badge: "bg-blue-100 text-blue-700",
      glow: "bg-blue-50",
      chip: "bg-gradient-to-br from-blue-500 to-blue-700"
    },
    "electric" => {
      bar: "bg-yellow-400",
      badge: "bg-yellow-100 text-yellow-700",
      glow: "bg-yellow-50",
      chip: "bg-gradient-to-br from-yellow-400 to-amber-500"
    },
    "psychic" => {
      bar: "bg-pink-400",
      badge: "bg-pink-100 text-pink-700",
      glow: "bg-pink-50",
      chip: "bg-gradient-to-br from-pink-400 to-fuchsia-600"
    },
    "ghost" => {
      bar: "bg-purple-500",
      badge: "bg-purple-100 text-purple-700",
      glow: "bg-purple-50",
      chip: "bg-gradient-to-br from-purple-500 to-violet-700"
    },
    "flying" => {
      bar: "bg-sky-400",
      badge: "bg-sky-100 text-sky-700",
      glow: "bg-sky-50",
      chip: "bg-gradient-to-br from-sky-400 to-indigo-400"
    },
    "poison" => {
      bar: "bg-fuchsia-600",
      badge: "bg-fuchsia-100 text-fuchsia-800",
      glow: "bg-fuchsia-50",
      chip: "bg-gradient-to-br from-fuchsia-600 to-purple-700"
    },
    "ground" => {
      bar: "bg-amber-700",
      badge: "bg-amber-100 text-amber-900",
      glow: "bg-amber-50",
      chip: "bg-gradient-to-br from-amber-600 to-amber-800"
    },
    "rock" => {
      bar: "bg-stone-500",
      badge: "bg-stone-200 text-stone-800",
      glow: "bg-stone-100",
      chip: "bg-gradient-to-br from-stone-500 to-stone-700"
    },
    "bug" => {
      bar: "bg-lime-500",
      badge: "bg-lime-100 text-lime-800",
      glow: "bg-lime-50",
      chip: "bg-gradient-to-br from-lime-500 to-lime-700"
    },
    "normal" => {
      bar: "bg-stone-400",
      badge: "bg-stone-100 text-stone-700",
      glow: "bg-stone-50",
      chip: "bg-gradient-to-br from-stone-400 to-stone-600"
    },
    "fighting" => {
      bar: "bg-red-700",
      badge: "bg-red-100 text-red-800",
      glow: "bg-red-50",
      chip: "bg-gradient-to-br from-red-600 to-red-900"
    },
    "ice" => {
      bar: "bg-cyan-400",
      badge: "bg-cyan-100 text-cyan-800",
      glow: "bg-cyan-50",
      chip: "bg-gradient-to-br from-cyan-400 to-sky-500"
    },
    "dragon" => {
      bar: "bg-indigo-600",
      badge: "bg-indigo-100 text-indigo-800",
      glow: "bg-indigo-50",
      chip: "bg-gradient-to-br from-indigo-600 to-violet-800"
    },
    "dark" => {
      bar: "bg-neutral-700",
      badge: "bg-neutral-200 text-neutral-900",
      glow: "bg-neutral-100",
      chip: "bg-gradient-to-br from-neutral-700 to-neutral-900"
    },
    "steel" => {
      bar: "bg-slate-400",
      badge: "bg-slate-200 text-slate-800",
      glow: "bg-slate-100",
      chip: "bg-gradient-to-br from-slate-400 to-slate-600"
    },
    "fairy" => {
      bar: "bg-rose-400",
      badge: "bg-rose-100 text-rose-800",
      glow: "bg-rose-50",
      chip: "bg-gradient-to-br from-rose-400 to-pink-500"
    }
  }.freeze

  def type_styles(type_name)
    TYPE_STYLES[type_name.to_s.downcase] || {
      bar: "bg-slate-400",
      badge: "bg-slate-100 text-slate-700",
      glow: "bg-slate-50",
      chip: "bg-gradient-to-br from-slate-500 to-slate-700"
    }
  end

  def format_height_dm(value)
    return "—" if value.nil?

    m = value.to_f / 10
    "#{m.round(1)} m"
  end

  def format_weight_hg(value)
    return "—" if value.nil?

    kg = value.to_f / 10
    "#{kg.round(1)} kg"
  end

  def stat_bar_width_percent(base_value)
    pct = (base_value.to_f / 255 * 100).round(1)
    [[pct, 100].min, 0].max
  end

  def ordered_pokemon_stats(pokemon)
    pokemon.pokemon_stats.sort_by do |s|
      idx = STAT_ORDER.index(s.name)
      idx.nil? ? 100 : idx
    end
  end

  def stat_label(name)
    name.to_s.tr("-", " ").split.map(&:capitalize).join(" ")
  end

  def pokemon_types_ordered(pokemon)
    pokemon.pokemon_types.includes(:type).ordered.map(&:type)
  end
end
