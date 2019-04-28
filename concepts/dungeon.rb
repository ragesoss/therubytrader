require_relative './place'
require_relative '../interfaces/in_dungeon'

class Dungeon < Place
  def initialize name, location: nil, biome: nil, depth: nil
    @name = name
    @location = location || TownPlacer.new_location(required_biome: biome)
    @biome = TownPlacer.biome(@location)
    @depth = depth || rand(3..5)
    @quests = []
  end

  def description
    "The dungeon of #{name}"
  end

  def enter
    InDungeon.new(self).create
  end

  def monsters
    @monsters ||= @depth.times.map { biome.random_encounter }
  end
end