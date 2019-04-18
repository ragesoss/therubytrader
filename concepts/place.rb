require_relative 'biomes/coast'
require_relative 'biomes/grassland'
require_relative 'biomes/marsh'
require_relative 'biomes/mountain'
require_relative 'biomes/river'

class Place
  attr_accessor :name, :location, :quests

  def biome
    Object.const_get Words.classname(@biome)
  end

  def key
    name.downcase.to_sym
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
    @lat ||= (BULLET_OFFSET_X + true_lat).to_i
  end

  def long
    @long ||= (BULLET_OFFSET_Y + true_long).to_i
  end
end