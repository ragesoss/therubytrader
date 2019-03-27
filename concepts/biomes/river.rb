require_relative '../biome'

require_relative '../enemies/goblin'
require_relative '../enemies/merfolk'
require_relative '../enemies/orc'
require_relative '../enemies/naga'
require_relative '../enemies/lizardman'

class River < Biome
  def self.monster_table
    {
      goblin: 3,
      orc: 3,
      merfolk: 1,
      naga: 1,
      lizardman: 2
    }
  end

  def self.adjective
    'riverside'
  end
end