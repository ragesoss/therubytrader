class Place
  attr_accessor :name, :location, :quests

  def biome
    Object.const_get(@biome.capitalize)
  end
end