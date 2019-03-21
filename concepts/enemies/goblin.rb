require_relative '../character'

class Goblin < Character
  def initialize
    @life = rand(2..7)

    SKILLS.each do |skill|
      send("#{skill}=", 1)
    end
  end

  def damage_range
    0..2
  end
end
