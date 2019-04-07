require_relative '../concepts/enemies/goblin'
require_relative '../concepts/enemies/ogre'
require_relative '../concepts/enemies/gargoyle'

class EncounterActions < Action
  def self.fight enemy, round
    FightRound.new(enemy, round).call
  end

  def self.run_from enemy, round
    if hit? $adventurer
      damage = enemy.damage
      $adventurer.take_damage damage
      return failure("Round #{round}: You can't get away! You were hit, and you lost #{damage} life.")
    else
      return success("Round #{round}: You got away!")
    end
  end

  def self.hit? character, advantage: 0, disadvantage: 0
    hit = rand > character.evasion_chance
    advantage.times { hit ||= rand > character.evasion_chance }
    miss = false
    disadvantage.times { miss ||= rand < character.evasion_chance }
    hit && !miss
  end

  def self.pick_monster destination
    destination.biome.random_encounter
  end

  def self.loot_body character
    $adventurer.money += character.money
    return unless character.inventory
    character.inventory.goods.each do |good, number|
      $adventurer.inventory.add good, number
    end
  end

  def self.gain_experience enemy
    $adventurer.experience[enemy.symbol] += 1
  end

  class FightRound
    def initialize enemy, round
      @enemy = enemy
      @round = round
      @advantage = $adventurer.advantage_versus enemy.class
      @disadvantage = @advantage / 3
    end

    def call
      @hit_enemy = EncounterActions.hit? @enemy, advantage: @advantage
      if @hit_enemy
        @damage_dealt = $adventurer.damage
        @enemy.take_damage @damage_dealt
      end
      return EncounterActions.success(result) unless @enemy.alive?
      @hit_adventurer = EncounterActions.hit? $adventurer, disadvantage: @advantage
      if @hit_adventurer
        @damage_taken = @enemy.damage
        $adventurer.take_damage @damage_taken
      end
      return EncounterActions.failure(result)
    end

    def result
      @result = String.new("Round #{@round}:")
      if @hit_enemy
        @result += "You hit for #{@damage_dealt}. "
      else
        @result += "You missed. "
      end

      if @enemy.dead?
        @result += "You killed #{@enemy.specific_name}!"
      elsif @hit_adventurer
        @result += "The enemy hit you for #{@damage_taken}."
      else
        @result += "The enemy missed."
      end
    end
  end
end
