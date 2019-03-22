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
    if is_water_color? *rgb
      return new_location
    end

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

  # account for the offset of the text bullet vs the location
  BULLET_OFFSET_X = -2
  BULLET_OFFSET_Y = -12 
  def self.window_location location
    ratio = 
    [
      (BULLET_OFFSET_X + location.first * WINDOW_TO_MAP_RATIO).to_i, # X
      (BULLET_OFFSET_Y + location.last * WINDOW_TO_MAP_RATIO).to_i # Y
    ]
  end
end


