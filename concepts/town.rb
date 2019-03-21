require_relative './market'

MAP_RANGE = 200..800

class Town
  attr_accessor :name, :population, :location
  def initialize name, population: nil, location: nil
    @name = name
    @population = population || rand(2000)
    @location = location || [rand(MAP_RANGE), rand(MAP_RANGE)]
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

  def lat
    location[0]
  end

  def long
    location[1]
  end
end
