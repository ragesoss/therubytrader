require_relative '../character'

class Goblin < Character
  def initialize
    @life = rand(2..7)
    @money = rand(5)

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
  end

  def name
    'a goblin'
  end

  def specific_name
    'the goblin'
  end

  def damage_range
    0..2
  end
end