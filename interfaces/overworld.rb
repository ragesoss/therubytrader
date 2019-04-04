require_relative '../actions/travel_actions'

YELLOW = Gosu::Color.argb(0xff_ffd972)
WHITE = Gosu::Color.argb(0xff_ffffff)
GRAY = Gosu::Color.argb(0xff_808080)
LIGHT_GRAY = Gosu::Color.argb(0xff_cccccc)
BLACK = Gosu::Color.argb(0xff_000000)

class Overworld < Interface
  def initialize location
    $state[:location] = location.key
    @location = location
    @map_offset_x = map_offset(location.location[0])
    @map_offset_y = map_offset(location.location[1])
    @background = Gosu::Image.new('media/overworld-large.png').subimage(@map_offset_x, @map_offset_y, WINDOW_SIZE, WINDOW_SIZE)
    @greeting = Gosu::Image.from_text($adventurer.status, 30)
    @prompt = Gosu::Image.from_text('Where do you want to travel?', 30)
    @far_towns_draw ||= far_towns.map do |town|
      pin = "• #{town.name}"
      image = Gosu::Image.from_text(pin, INACTIVE_SIZE)
      [town, image]
    end

    @selected_option = nearby_towns.index location
    setup_input_handling
    set_actions
  end

  def map_offset coordinate
    if coordinate < (WINDOW_SIZE / 2)
      0
    elsif coordinate > (MAP_SIZE - (WINDOW_SIZE / 2))
      (MAP_SIZE - WINDOW_SIZE)
    else
      coordinate - (WINDOW_SIZE / 2)
    end
  end

  def towns
    $state[:towns].values
  end

  def max_travel
    @max_travel ||= 250 + 100 * $adventurer.survival
  end

  def nearby_towns
    @nearby_towns ||= towns.select do |town|
      Distance.between(town.location, @location.location) <= max_travel
    end
  end

  def options
    nearby_towns
  end

  def far_towns
    @far_towns ||= towns.select do |town|
      Distance.between(town.location, @location.location) > max_travel
    end
  end

  def set_actions
    nearby_towns.each do |town|
      define_singleton_method(town.key) do
        destroy
        TravelActions.set_off_to(town)
      end
    end
  end

  ACTIVE_SIZE = 30
  INACTIVE_SIZE = 20
  def draw
    @background.draw 0, 0, 0
    super
    selected_town = nearby_towns[@selected_option]
    Gosu::Image.from_text(selected_town.description, 40).draw 10, 1350, 0
    @far_towns_draw.each do |town, label|
      label.draw town.lat - @map_offset_x, town.long - @map_offset_y, 2, 1, 1, LIGHT_GRAY
      label.draw town.lat - @map_offset_x + 1, town.long - @map_offset_y + 1, 1, 1, 1, BLACK
    end

    nearby_towns.each.with_index do |town, i|
      selected = @selected_option == i
      style = selected ? { bold: true } : {}
      z_index = selected ? 3 : 1
      pin = "• #{town.name}"
      color = if town == @location
                YELLOW
              elsif selected
                WHITE
              else
                GRAY
              end
      # label
      Gosu::Image.from_text(pin, ACTIVE_SIZE, style).draw town.lat - @map_offset_x, town.long - @map_offset_y, z_index + 1, 1, 1, color
      # shadow
      Gosu::Image.from_text(pin, ACTIVE_SIZE, style).draw town.lat - @map_offset_x + 2, town.long - @map_offset_y + 2, z_index, 1, 1, BLACK
    end
  end

  def take_action
    selected_action = nearby_towns[@selected_option].key
    send selected_action
  end
end
