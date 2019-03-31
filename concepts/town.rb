require_relative './market'
require_relative '../utilities/town_placer'
require_relative './place'

class Town < Place
  attr_accessor :population
  def initialize name, population: nil, location: nil, biome: nil
    @name = name
    @population = population || rand(2000)
    @location = location || TownPlacer.new_location(required_biome: biome)
    @biome = TownPlacer.biome @location
    @color = TownPlacer.map_reader.color *@location
    @quests = []
  end

  def population_attributes
    case population
    when 1..100
      ['tiny', 'village']
    when 101..200
      ['small', 'village']
    when 201..300
      ['modest', 'village']
    when 301..500
      ['a bustling', 'village']
    when 501..800
      ['a small', 'town']
    when 801..2000
      ['a modest', 'town']
    when 2001..3000
      ['a large', 'town']
    when 3001..5000
      ['a small', 'city']
    when 5001..10000
      ['a busy', 'city']
    when 10001..15000
      ['a teeming', 'city']
    when 15001..20000
      ['an expansive', 'city']
    when 20001..80000
      ['an enormous', 'city']
    when 80001..500000
      ['a seemingly endless', 'metropolis']
    end
  end

  def size_adjective
    @size_adjective ||= population_attributes[0]
  end

  def main_descriptor
    @main_descriptor ||= population_attributes[1]
  end

  def description
    "#{name}, #{size_adjective} #{biome.adjective} #{main_descriptor} of #{population}"
  end

  def key
    name.downcase.to_sym
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
  def lat
    @lat ||= (BULLET_OFFSET_X + true_lat * MAP_RATIO).to_i
  end

  def long
    @long ||= (BULLET_OFFSET_Y + true_long * MAP_RATIO).to_i
  end
end
