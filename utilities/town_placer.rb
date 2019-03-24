require_relative './map_reader.rb'
require_relative '../concepts/quests/ascend'

class TownPlacer
  MAP_RANGE = 1..2000
  # adapted from https://www.redblobgames.com/maps/mapgen2/colormap.js
  BIOME_COLORS = {
    ocean: "#44447a",
    ocean_border: "#33335a",
    lakeshore: "#225588",
    lake: "#336699",
    river: "#225588",
    marsh: "#2f6666",
    glacier: "#99ffff",
    coast: "#a09077",
    snow: "#ffffff",
    tundra: "#bbbbaa",
    wasteland: "#888888",
    mountain: "#555555",
    taiga: "#99aa77",
    shrubland: "#889977",
    temperate_desert: "#c9d29b",
    temperate_rain_forest: "#448855",
    temperate_deciduous_forest: "#679459",
    grassland: "#88aa55",
    subtropical_desert: "#d2b98b",
    tropical_rain_forest: "#337755",
    tropical_seasonal_forest: "#559944"
  }

  TOWN_NAMES = %w[Abelmoschus Anthemis Apium Brassica Carpinus Erycina Flossvale
                  Govenia Garaya Holopogon Isotria Lanium Larix Macodes Mixis
                  Mume Olea Ophrys Orchedo Palmatum Panisea Passiflora Podangis
                  Quercus Rana Risleya Salix Solanum Stenia Thuja Trias Vanda
                  Yoania]
  def self.generate_towns
    $state[:towns] = {}
    TOWN_NAMES.each do |town_name|
      $state[:towns][town_name.downcase.to_sym] = Town.new(town_name)
    end
    $state[:towns][:palmatum].quests = [Ascend.new(:palmatum)]
  end

  def self.map_reader
    @map_reader ||= MapReader.new 'media/overworld-base.png'
  end

  def self.new_location
    location = random_location

    color = map_reader.color *location
    if ocean_color? color
      return new_location
    elsif too_close_to_another_town? location
      return new_location
    end

    location
  end

  def self.random_location
    [rand(MAP_RANGE), rand(MAP_RANGE)]
  end

  def self.ocean_color? color
    map_reader.basically_the_same_colors? color, BIOME_COLORS[:ocean]
  end

  MIN_DISTANCE = 180
  def self.too_close_to_another_town? location
    return false if $state[:towns].empty?

    return false if rand(8) == 0 # allow a few too-close towns: twin cities
    Distance.to_nearest_town(location) < MIN_DISTANCE
  end

  def self.biome location
    color = map_reader.color(*location)
    BIOME_COLORS.each do |biome, hex_color|
      return biome if map_reader.basically_the_same_colors? color, hex_color
    end
    :unknown
  end
end
