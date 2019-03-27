require_relative '../biome'

require_relative '../enemies/goblin'
require_relative '../enemies/ogre'
require_relative '../enemies/orc'
require_relative '../enemies/troll'
require_relative '../enemies/goblin_wolfrider'

class Mountain < Biome
  def self.monster_table
    {
      goblin: 2,
      goblin_wolfrider: 2,
      orc: 3,
      ogre: 1,
      troll: 1
    }
  end

  def self.adjective
    'mountain'
  end
end