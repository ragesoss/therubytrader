class Ogre < Character
  def initialize
    @life = rand(11..21)
    @money = rand(60)
    @inventory = Inventory.new
    @inventory.add(:hide, rand(4))
    @inventory.add(:silver, rand(3)) if rand > 0.85

    SKILLS.each do |skill|
      send("#{skill}=", 2)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/ogre.png')
  end

  def name
    'an ogre'
  end

  def specific_name
    'the ogre'
  end

  def damage_range
    1..5
  end
end
