require_relative '../character'

class Naga < Character
  def initialize
    @life = rand(4..7)
    @money = rand(10)
    @inventory = Inventory.new
    @inventory.add(:silver, 1) if rand > 0.9

    SKILLS.each do |skill|
      send("#{skill}=", 3)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/naga.png')
  end

  def name
    'a naga'
  end

  def specific_name
    'the naga'
  end

  def damage_range
    1..4
  end
end