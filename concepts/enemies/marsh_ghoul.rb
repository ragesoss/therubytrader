require_relative '../character'

class MarshGhoul < Character
  def initialize
    @life = rand(15..28)
    @inventory = Inventory.new
    @inventory.add(:relics, 1) if rand > 0.85
    @inventory.add(:silver, 1) if rand > 0.85
    @inventory.add(:ruby, 1) if rand > 0.99

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/marsh_ghoul.png')
  end

  def name
    'a marsh ghoul'
  end

  def specific_name
    'the ghoul'
  end

  def damage_range
    6..10
  end
end