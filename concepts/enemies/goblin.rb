require_relative '../character'

class Goblin < Character
  def initialize
    @life = rand(2..7)
    @money = rand(5)
    @inventory = Inventory.new
    @inventory.add(:food, rand(3)) if rand > 0.6

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/goblin.png')
  end

  def name
    'a goblin'
  end

  def specific_name
    'the goblin'
  end

  def damage_range
    0..2
  end
end
