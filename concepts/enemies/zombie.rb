require_relative '../character'

class Zombie < Character
  def initialize
    @life = rand(2..8)

    SKILLS.each do |skill|
      send("#{skill}=", 2)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/zombie.png')
  end

  def name
    'a zombie'
  end

  def specific_name
    'the zombie'
  end

  def damage_range
    0..2
  end
end