require 'rmagick'

class MapReader
  def initialize file
    @file = file
    @image = Magick::Image::read(file).first
  end

  def patch(row, column)
    @image.get_pixels(row, column, 3, 3)
  end

  def average_value(row, column)
    h = []
    s = []
    l = []
    patch(row, column).each do |pixel|
      hsla = pixel.to_hsla

      next if hsla[0] == 0.0

      h << hsla[0]
      s << hsla[1]
      l << hsla[2]
    end
    return [0, 0, 0] if h.empty?
    [h.sum / h.count, s.sum / s.count, l.sum / l.count]
  rescue => e
    puts row, column
    raise e
  end

  #############
  # DEBUGGING #
  #############
  def mark_location row, column
    10.times do |i|
      this_row = row + i
      10.times do |j|
        this_column = column + j
        @image.pixel_color(this_row, this_column, 'fuchsia')
      end
    end
  end

  def write_image
    @image.write 'media/overworld.marked.png'
  end
end
