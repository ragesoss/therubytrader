require_relative './place'
require_relative '../interfaces/in_dungeon'

class Dungeon < Place
  def initialize name, location: nil, biome: nil
    @name = name
    @location = location || TownPlacer.new_location(required_biome: biome)
    @biome = TownPlacer.biome @location
    @quests = []
  end

  def description
    "The dungeon of #{name}"
  end

  def enter
    InDungeon.new(self).create
  end
end