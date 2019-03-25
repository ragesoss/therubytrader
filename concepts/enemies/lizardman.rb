require_relative '../character'

class Lizardman < Character
  def initialize
    @life = rand(3..7)
    @money = rand(10)
    @inventory = Inventory.new
    @inventory.add(:tools, 1) if rand > 0.9
    @inventory.add(:silver, 1) if rand > 0.9
    @inventory.add(:hide, 1) if rand > 0.9

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/lizardman.png')
  end

  def name
    'a lizardman'
  end

  def specific_name
    'the thelizardman'
  end

  def damage_range
    1..3
  end
end