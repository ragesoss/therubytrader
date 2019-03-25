require_relative '../biome'
require_relative '../enemies/merfolk'
require_relative '../enemies/naga'
require_relative '../enemies/sea_serpent'

class Coast < Biome
  def self.monster_table
    {
      goblin: 5,
      merfolk: 4,
      naga: 3,
      sea_serpent: 1,
      ogre: 1
    }
  end
end