require 'chunky_png'

class MapReader
  def initialize file
    @file = file
    @image = ChunkyPNG::Image.from_file @file
  end

  def color row, column
    @image[row, column]
  end

  def basically_the_same_colors? color, hex_color
    color_2 = ChunkyPNG::Color.from_hex hex_color
    ChunkyPNG::Color.euclidean_distance_rgba(color, color_2) < 10
  end
end
