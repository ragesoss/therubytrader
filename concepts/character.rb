require_relative './skills'
require_relative '../utilities/words'

class Character
  attr_accessor :name, :life, :money, :inventory
  attr_accessor *SKILLS

  def change_skill skill, amount = 1
    send("#{skill}=", send(skill) + amount)
  end

  def damage
    rand(damage_range) + swordfighting
  end

  def evasion_chance
    1 - 1.0/(1 + stealth)
  end

  def take_damage amount
    @life -= amount
  end

  def alive?
    @life.positive?
  end

  def dead?
    !alive?
  end

  def image
    nil
  end

  def money
    @money || 0
  end

  def loot
    contents = ["#{money} #{MONEY}"]
    return contents.first unless inventory

    inventory.goods.each do |good, count|
      next unless count.positive?

      contents << "#{count} #{good}"
    end
    Words.comma_list contents
  end
end
