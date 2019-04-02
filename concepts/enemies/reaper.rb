class Reaper < Character
  def initialize
    @life = rand(3..7)
    @money = 0
    @inventory = Inventory.new
    @inventory.add(:silver, rand(3)) if rand > 0.5

    SKILLS.each do |skill|
      send("#{skill}=", 3)
    end
  end

  def image
    @image ||= Gosu::Image.new('media/reaper.png')
  end

  def name
    'a reaper'
  end

  def specific_name
    'the reaper'
  end

  def damage_range
    2..5
  end
end
