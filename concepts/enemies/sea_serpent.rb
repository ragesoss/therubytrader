require_relative '../character'

class SeaSerpent < Character
  def initialize
    @life = rand(12..19)
    @money = 0
    @inventory = Inventory.new
    @inventory.add(:hide, rand(4))

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/sea_serpent.png')
  end

  def name
    'a sea serpent'
  end

  def specific_name
    'the great serpent'
  end

  def damage_range
    5..11
  end
end