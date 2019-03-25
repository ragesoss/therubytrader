require_relative '../biome'
require_relative '../enemies/orc'
require_relative '../enemies/reaper'
require_relative '../enemies/goblin'
require_relative '../enemies/ogre'

class Grassland < Biome
  def self.monster_table
    {
      goblin: 12,
      orc: 8,
      ogre: 1,
      reaper: 1
    }
  end
end