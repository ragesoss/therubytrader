require_relative '../concepts/enemies/goblin'
require_relative '../concepts/enemies/ogre'
require_relative '../concepts/enemies/gargoyle'

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
    when 0..80
      Goblin.new
    when 81..93
      Gargoyle.new
    when 94..100
      Ogre.new
    end
  end

  def self.loot_body character
    $adventurer.money += character.money
    return unless character.inventory
    character.inventory.goods.each do |good, number|
      $adventurer.inventory.add good, number
    end
  end
end
