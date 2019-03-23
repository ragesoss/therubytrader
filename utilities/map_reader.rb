require 'rmagick'
# require 'chunky_png'

class MapReader
  def initialize file
    @file = file
    @image = Magick::Image::read(file).first
    # chunky_png version:
    # @image = ChunkyPNG::Image.from_file @file
  end

  def patch(row, column)
    @image.get_pixels(row, column, 3, 3)
    # chunky_png version:
    # pixels = []
    # 3.times do |i|
    #   3.times do |j|
    #     pixels << @image[row + i, column + j]
    #   end
    # end
    # pixels
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
      # chunky_png version:
      # hsl = ChunkyPNG::Color.to_hsl pixel
      # h << hsl[0]
      # s << hsl[1] * 255
      # l << hsl[2] * 255
      # next if hsl[0] == 0.0
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
