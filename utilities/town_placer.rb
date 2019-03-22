require_relative './map_reader.rb'

class TownPlacer
  WINDOW_TO_MAP_RATIO = 0.5
  MAP_RANGE = 1..2000


  def self.map_reader
    @map_reader ||= MapReader.new 'media/overworld.png'
  end

  def self.new_location
    location = random_location
    rgb = map_reader.average_value *location
    pp rgb
    if is_water_color? *rgb
      return new_location
    end

    pp 'that was it'
    window_location location
  end

  def self.random_location
    [rand(MAP_RANGE), rand(MAP_RANGE)]
  end

  def self.is_water_color? r, g, b
    rg_ratio = r.to_f / g
    rb_ratio = r.to_f / b
    (0.95..1.05).cover?(rg_ratio) && (0.54..0.60).cover?(rb_ratio)
  end

  BULLET_OFFSET = 10 # account for the vertical offset of the text bullet vs the location
  def self.window_location location
    ratio = 
    [
      (location.first * WINDOW_TO_MAP_RATIO).to_i, # X
      (BULLET_OFFSET + location.last * WINDOW_TO_MAP_RATIO).to_i # Y
    ]
  end
end


