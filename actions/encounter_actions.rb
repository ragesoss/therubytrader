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
end
