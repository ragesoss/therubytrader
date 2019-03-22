require_relative './map_reader.rb'

class TownPlacer
  MAP_RANGE = 1..2000

  def self.map_reader
    @map_reader ||= MapReader.new 'media/overworld.png'
  end

  def self.new_location
    location = random_location

    rgb = map_reader.average_value *location
    if is_water_color? *rgb
      return new_location
    end

    location
  end

  def self.random_location
    [rand(MAP_RANGE), rand(MAP_RANGE)]
  end

  def self.is_water_color? r, g, b
    rg_ratio = r.to_f / g
    rb_ratio = r.to_f / b
    (0.95..1.05).cover?(rg_ratio) && (0.54..0.60).cover?(rb_ratio)
  end
end


