require_relative './market'
require_relative '../utilities/town_placer'

class Town
  attr_accessor :name, :population, :location
  def initialize name, population: nil, location: nil
    @name = name
    @population = population || rand(2000)
    @location = location || TownPlacer.new_location
  end

  def key
    name.downcase.to_sym
  end

  def describe
    "You're in #{name}, a town of #{population}."
  end

  def market
    @market ||= Market.new(self)
  end

  def inn_cost
    @inn_cost ||= rand(5..15)
  end

  def true_lat
    location[0]
  end

  def true_long
    location[1]
  end

  # account for the offset of the text bullet vs the location,
  # as well as the ratio between the window and the map image
  BULLET_OFFSET_X = -2
  BULLET_OFFSET_Y = -12
  WINDOW_TO_MAP_RATIO = 0.5
  def lat
    @lat ||= (BULLET_OFFSET_X + true_lat * WINDOW_TO_MAP_RATIO).to_i
  end

  def long
    @long ||= (BULLET_OFFSET_Y + true_long * WINDOW_TO_MAP_RATIO).to_i
  end
end
