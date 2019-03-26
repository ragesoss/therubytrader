require_relative '../character'

class GoblinWolfrider < Character
  def initialize
    @life = rand(3..8)
    @money = rand(15)
    @inventory = Inventory.new
    @inventory.add(:food, rand(4)) if rand > 0.2
    @inventory.add(:cloth, rand(3)) if rand > 0.4
    @inventory.add(:silver, 1) if rand > 0.93

    SKILLS.each do |skill|
      send("#{skill}=", 2)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/goblin_wolfrider.png')
  end

  def name
    'a goblin wolfrider'
  end

  def specific_name
    'the wolfrider'
  end

  def damage_range
    0..3
  end
end
