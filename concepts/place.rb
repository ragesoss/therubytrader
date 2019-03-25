require_relative 'biomes/coast'
require_relative 'biomes/grassland'

class Place
  attr_accessor :name, :location, :quests

  def biome
    Object.const_get Words.classname(@biome)
  end
end