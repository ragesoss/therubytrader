require_relative './place'

class Dungeon < Place
  def initialize name, location: nil, biome: nil
    @name = name
    @location = location || TownPlacer.new_location(required_biome: biome)
    @biome = TownPlacer.biome @location
    @quests = []
  end
end