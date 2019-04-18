require_relative './market'
require_relative '../utilities/town_placer'
require_relative './place'

class Town < Place
  attr_accessor :population
  def initialize name, population: nil, location: nil, biome: nil
    @name = name
    @population = population || rand(2000)
    @location = location || TownPlacer.new_location(required_biome: biome)
    @biome = TownPlacer.biome @location
    @color = TownPlacer.map_reader.color *@location
    @quests = []
  end

  # [adjective, noun, image_filename]
  def population_attributes
    case population
    when 1..100
      ['tiny', 'village', 'village-tiny']
    when 101..200
      ['small', 'village', 'village-small' ]
    when 201..300
      ['modest', 'village', 'village-medium']
    when 301..500
      ['a bustling', 'village', 'village-large']
    when 501..800
      ['a small', 'town', 'town-small']
    when 801..2000
      ['a modest', 'town', 'town-medium']
    when 2001..3000
      ['a large', 'town', 'town-large']
    when 3001..5000
      ['a small', 'city', 'city-small']
    when 5001..10000
      ['a busy', 'city', 'city-medium']
    when 10001..15000
      ['a teeming', 'city', 'city-large']
    when 15001..20000
      ['an expansive', 'city', 'city-large']
    when 20001..80000
      ['an enormous', 'city', 'city-large']
    when 80001..500000
      ['a seemingly endless', 'metropolis', 'metropolis']
    end
  end

  def size_adjective
    @size_adjective ||= population_attributes[0]
  end

  def main_descriptor
    @main_descriptor ||= population_attributes[1]
  end

  def image
    if File.exist? "media/towns/#{main_descriptor}/#{biome_prefix}#{image_filename_base}.png"
      "media/towns/#{main_descriptor}/#{biome_prefix}#{image_filename_base}.png"
    else
      "media/towns/#{main_descriptor}/#{image_filename_base}.png"
    end
  end

  def description
    "#{name}, #{size_adjective} #{biome.adjective} #{main_descriptor} of #{population}"
  end

  def market
    @market ||= Market.new(self)
  end

  def inn_cost
    @inn_cost ||= rand(5..15)
  end

  def set_background
    map_offset_x = Map.offset(location[0])
    map_offset_y = Map.offset(location[1])
    $backgrounds[key] ||= Gosu::Image.new('media/overworld-large.png')
                                     .subimage(map_offset_x, map_offset_y,
                                               WINDOW_SIZE, # width
                                               WINDOW_SIZE - Overworld::TOP_MARGIN - Overworld::BOTTOM_MARGIN) #height
  end

  private

  def biome_prefix
    case @biome
    when :coast, :ocean_border
      'coast-'
    when :river
      'river-'
    else
      ''
    end
  end

  def image_filename_base
    population_attributes[2]
  end
end
