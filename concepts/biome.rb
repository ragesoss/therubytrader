class Biome
  # adapted from https://www.redblobgames.com/maps/mapgen2/colormap.js
  COLORS = {
    ocean: "#44447a",
    ocean_border: "#33335a",
    lakeshore: "#225588",
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

  def self.random_encounter
    case rand(100)
    when 0..80
      Goblin.new
    when 81..93
      Gargoyle.new
    when 94..100
      Ogre.new
    end
  end

  COLORS.keys.each do |biome|
    Object.const_set biome.capitalize, Class.new(Biome)
  end
end