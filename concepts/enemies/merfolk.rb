require_relative '../character'

class Merfolk < Character
  def initialize
    @life = rand(5..8)
    @money = rand(25)
    @inventory = Inventory.new
    @inventory.add(:silver, rand(3)) if rand > 0.8

    SKILLS.each do |skill|
      send("#{skill}=", 3)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/merfolk.png')
  end

  def name
    'a mer warrior'
  end

  def specific_name
    'the merman'
  end

  def damage_range
    1..4
  end
end
