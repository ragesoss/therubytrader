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
end
