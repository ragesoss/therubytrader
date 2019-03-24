require_relative '../character'

class Gargoyle < Character
  def initialize
    @life = rand(7..15)
    @money = 2
    @inventory = Inventory.new
    @inventory.add(:relics, 1) if rand > 0.95

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/gargoyle.png')
  end

  def name
    'a gargoyle'
  end

  def specific_name
    'the gargoyle'
  end

  def damage_range
    0..4
  end
end
