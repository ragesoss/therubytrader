require 'rmagick'

class MapReader
  def initialize file
    @file = file
    @image = Magick::Image::read(file).first
  end

  def patch(row, column)
    @image.get_pixels(row, column, 3, 3)
  end

  IGNORE_COLORS = %w[black gray]
  def average_value(row, column)
    r = []
    g = []
    b = []
    patch(row, column).each do |pixel|
      # color => "#5E5E9B9B7E7E" or "black", etc
      color = pixel.to_color
      next if IGNORE_COLORS.any? { |name| color.include? name }

      r << color[1..2].hex
      g << color[5..6].hex
      b << color[9..10].hex
    end
    [r.sum / r.count, g.sum / g.count, b.sum / b.count]
  rescue => e
    puts color
    puts row, column
    raise e
  end
end
