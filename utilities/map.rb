class Map
  def self.offset coordinate
    if coordinate < (WINDOW_SIZE / 2)
      0
    elsif coordinate > (MAP_SIZE - (WINDOW_SIZE / 2))
      (MAP_SIZE - WINDOW_SIZE)
    else
      coordinate - (WINDOW_SIZE / 2)
    end
  end
end