require_relative '../character'

class Orc < Character
  def initialize
    @life = rand(3..8)
    @money = rand(8)
    @inventory = Inventory.new
    @inventory.add(:food, rand(3)) if rand > 0.6
    @inventory.add(:tools, rand(2)) if rand > 0.6

    SKILLS.each do |skill|
      send("#{skill}=", 3)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/orc.png')
  end

  def name
    'an orc'
  end

  def specific_name
    'the orc'
  end

  def damage_range
    1..3
  end
end