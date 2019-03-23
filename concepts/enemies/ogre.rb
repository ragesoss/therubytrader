class Ogre < Character
  def initialize
    @life = rand(11..21)
    @money = rand(50)

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
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
