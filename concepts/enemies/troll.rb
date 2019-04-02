require_relative '../character'

class Troll < Character
  def initialize
    @life = rand(15..30)
    @money = rand(20)
    @inventory = Inventory.new
    @inventory.add(:food, rand(6)) if rand > 0.3
    @inventory.add(:hide, rand(4)) if rand > 0.4
    @inventory.add(:tools, rand(2)) if rand > 0.6
    @inventory.add(:rubies, 1) if rand > 0.97
    @inventory.add(:silver, rand(4)) if rand > 0.6

    SKILLS.each do |skill|
      send("#{skill}=", 4)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/troll.png')
  end

  def name
    'a troll'
  end

  def specific_name
    'the troll'
  end

  def damage_range
    5..10
  end
end