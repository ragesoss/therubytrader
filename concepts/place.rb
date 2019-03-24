require_relative 'biomes/coast'

class Place
  attr_accessor :name, :location, :quests

  def biome
    Object.const_get Words.classname(@biome)
  end
end