require_relative './map_reader.rb'

class TownPlacer
  MAP_RANGE = 1..2000

  def self.map_reader
    @map_reader ||= MapReader.new 'media/overworld.png'
  end

  def self.new_location
    location = random_location

    hsl = map_reader.average_value *location
    if water_color? *hsl
      return new_location
    elsif too_close_to_another_town? location
      return new_location
    end

    location
  end

  def self.random_location
    [rand(MAP_RANGE), rand(MAP_RANGE)]
  end

  def self.water_color? h, s, l
    (239..241).cover? h
  end

  MIN_DISTANCE = 180
  def self.too_close_to_another_town? location
    return false if $state[:towns].nil?

    return false if rand(8) == 0 # allow a few too-close towns: twin cities
    Distance.to_nearest_town(location) < MIN_DISTANCE
  end

  def self.biome location
    h, s, l = *map_reader.average_value(*location)
    # mountain: 0, 0, 0
    # coast : 36, 42, 122
    # coast:  36, 42, 125
    # coast: 105, 47, 108
    # coast: 67, 55, 92
    # coast: 74, 90, 97
    # not coast: 93, 37, 118
    # not coast: 91, 43, 103
    # not coast: 91, 41, 107
    # plains: 70, 100, 192
    # desert: 39, 114, 183
    # desert: 37, 97, 140
    # desert: 37, 103, 155
    # forest: 80, 59, 148
    # forest: 110, 120, 82
    # forest: 106, 79, 91
    # forest: 110, 114, 71
    # forest: 108, 81, 49
    # forest : 87, 104, 98
    # forest: 63, 112, 32
    # forest: 85, 89, 119
    # forest : 81, 51, 108
    # forest: 95, 97, 52
    # forest river valley: 151, 73, 112
    # jungle: 147, 119, 60
    # jungle: 147, 122, 58
    # swamp: 180, 90, 77
    # swamp: 180, 95, 71
    # lake: 210, 128, 100
    # forest or plains: 83, 92, 48
    if h < 10
      :mountain
    elsif (h > 85) && (h < 96) && (s > 35) && (s < 45) && (l > 100)
      :badlands
    elsif (h < 80) && (s > 40) && (s < 60) && (l > 90)
      :coast
    elsif (h < 50) && (l > 130)
      :desert
    elsif (h > 60) && (h < 110) && (l > 150)
      :grassland
    elsif (h > 60) && (h < 160) & (l > 45)
      :forest
    elsif (h > 130) && (h < 160) && (l < 70)
      :jungle
    elsif (h > 200) && (s > 100)
      :lake
    elsif (h > 160) && (l > 65)
      :swamp
    else
      :unknown
    end
  end
end
