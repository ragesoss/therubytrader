class Biome
  # adapted from https://www.redblobgames.com/maps/mapgen2/colormap.js
  COLORS = {
    ocean: "#44447a",
    ocean_border: "#33335a",
    # lakeshore: "#225588",
    lake: "#336699",
    river: "#225588",
    marsh: "#2f6666",
    glacier: "#99ffff",
    coast: "#a09077",
    snow: "#ffffff",
    tundra: "#bbbbaa",
    wasteland: "#888888",
    mountain: "#555555",
    taiga: "#99aa77",
    shrubland: "#889977",
    temperate_desert: "#c9d29b",
    temperate_rain_forest: "#448855",
    temperate_deciduous_forest: "#679459",
    grassland: "#88aa55",
    subtropical_desert: "#d2b98b",
    tropical_rain_forest: "#337755",
    tropical_seasonal_forest: "#559944"
  }

  def self.bag_of_monsters
    @bag_of_monsters ||= fill_bag
  end

  def self.fill_bag
    bag = []
    monster_table.each do |monster, count|
      count.times { bag << monster }
    end
    bag
  end

  def self.monster_table
    {
      goblin: 14,
      gargoyle: 2,
      ogre: 1
    }
  end

  def self.random_encounter
    monster = bag_of_monsters.sample
    Object.const_get(Words.classname(monster)).new
  end

  def self.adjective
    'mysterious'
  end

  IMPLEMENTED = %i[coast grassland marsh mountain]
  COLORS.keys.each do |biome|
    next if IMPLEMENTED.include? biome
    Object.const_set Words.classname(biome), Class.new(Biome)
  end
  Object.const_set Words.classname(:unknown_biome), Class.new(Biome)
end