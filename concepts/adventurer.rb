require_relative './inventory'
require_relative './character'

class Adventurer < Character
  def initialize name
    @name = name
    @max_life = 20
    @life = 20
    @money = 100
    @inventory = Inventory.new

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
  end

  def status
    "You have #@life life. You have #@money #{MONEY}."
  end

  def heal!
    @life = @max_life
  end

  def can_afford? cost
    money >= cost
  end

  def pay cost
    @money -= cost
  end

  def get_paid amount
    @money += amount
  end

  def damage_range
    0..3
  end

  MAX_WEIGHT = 100
  def encumbered?
    pp inventory.weight
    inventory.weight > MAX_WEIGHT
  end
end
