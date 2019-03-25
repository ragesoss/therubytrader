require_relative '../biome'

require_relative '../enemies/goblin'
require_relative '../enemies/lizardman'
require_relative '../enemies/zombie'
require_relative '../enemies/marsh_ghoul'
require_relative '../enemies/reaper'

class Marsh < Biome
  def self.monster_table
    {
      goblin: 2,
      lizardman: 6,
      zombie: 4,
      marsh_ghoul: 1,
      reaper: 1
    }
  end
end