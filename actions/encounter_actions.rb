require_relative '../concepts/enemies/goblin'
require_relative '../concepts/enemies/ogre'

class EncounterActions < Action
  def self.fight enemy
    if hit? enemy
      enemy.take_damage $adventurer.damage
    end
    return success unless enemy.alive?
    if hit? $adventurer
      $adventurer.take_damage enemy.damage
    end
    return failure
  end

  def self.run_from enemy
    if hit? $adventurer
      $adventurer.take_damage enemy.damage
      return failure
    else
      return success
    end
  end

  def self.hit? character
    rand > character.evasion_chance
  end

  def self.pick_monster
    case rand(100)
    when 0..85
      Goblin.new
    when 86..100
      Ogre.new
    end
  end

  def self.loot_body character
    $adventurer.money += character.money
  end
end
