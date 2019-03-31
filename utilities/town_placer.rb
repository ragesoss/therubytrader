require_relative './map_reader.rb'
require_relative '../concepts/quests/ascend'
require_relative '../concepts/quests/bad_penny'
require_relative '../concepts/biome'

class TownPlacer
  MAP_RANGE = 1..2000
  TOWN_NAMES = %w[Abelmoschus Anthemis Apium Artemisia Brassica Carpinus Erycina Flossvale
                  Govenia Garaya Holopogon Isotria Lanium Larix Macodes Malus Mixis
                  Mume Olea Ophiopogon Ophrys Orchedo Palmatum Panisea Passiflora Pimpinella Podangis
                  Quercus Rana Risleya Salix Solanum Stenia Thuja Tradescantia Trias Vanda
                  Yoania]

  MIN_BIOME_COUNTS = {
    mountain: 1,
    river: 4,
    snow: 1,
    tundra: 1,
    lake: 1,
    marsh: 2,
    coast: 10,
    tropical_rain_forest: 1
  }

  def self.pick_town_size
    case rand 100
    when 0..500 # village
      rand 1..500
    when 41..80 # town
      rand 501..3000
    when 81..90 # city
      rand 3001..20000
    when 91..98 # large city
      rand 20001..80000
    when 99 # mega city
      rand 80001..500000
    end
  end

  def self.unplaced_towns
    TOWN_NAMES - $state[:towns].values.collect(&:name)
  end

  def self.generate_towns
    $state[:towns] = {}

    MIN_BIOME_COUNTS.each do |biome, count|
      count.times do
        town_name = unplaced_towns.sample
        $state[:towns][town_name.downcase.to_sym] = Town.new(town_name, biome: biome, population: pick_town_size)
      end
    end

    unplaced_towns.each do |town_name|
      $state[:towns][town_name.downcase.to_sym] = Town.new(town_name, population: pick_town_size)
    end

    add_quests
  end

  def self.add_quests
    # Ascend
    ascension_town = TOWN_NAMES.sample
    $state[:towns][ascension_town.downcase.to_sym].quests = [Ascend.new(ascension_town.downcase.to_sym)]

    # BadPenny
    town = TOWN_NAMES.sample
    $state[:towns][town.downcase.to_sym].quests = [BadPenny.new(town.downcase.to_sym)]
  end


  def self.map_reader
    @map_reader ||= MapReader.new 'media/overworld-base.png'
  end

  def self.new_location required_biome: nil
    location = random_location
  
    color = map_reader.color *location
    if required_biome && biome(location) != required_biome
      return new_location required_biome: required_biome
    elsif ocean_color? color
      return new_location required_biome: required_biome
    elsif too_close_to_another_town? location
      return new_location required_biome: required_biome
    end

    location
  end

  def self.random_location
    [rand(MAP_RANGE), rand(MAP_RANGE)]
  end

  def self.ocean_color? color
    map_reader.basically_the_same_colors? color, Biome::COLORS[:ocean]
  end

  MIN_DISTANCE = 180
  def self.too_close_to_another_town? location
    return false if $state[:towns].empty?

    return false if rand(15) == 0 # allow a few too-close towns: twin cities
    Distance.to_nearest_town(location) < MIN_DISTANCE
  end

  def self.biome location
    color = map_reader.color(*location)
    Biome::COLORS.each do |biome, hex_color|
      return biome if map_reader.basically_the_same_colors? color, hex_color
    end
    :unknown_biome
  end
end
