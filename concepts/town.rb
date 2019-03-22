require_relative './market'
require_relative '../utilities/town_placer'

class Town
  attr_accessor :name, :population, :location
  def initialize name, population: nil, location: nil
    @name = name
    @population = population || rand(2000)
    pp @name
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

  def lat
    location[0]
  end

  def long
    location[1]
  end
end
