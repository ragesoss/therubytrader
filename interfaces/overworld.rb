require_relative '../actions/travel_actions'
require_relative '../utilities/map'

YELLOW = Gosu::Color.argb(0xff_ffd972)
WHITE = Gosu::Color.argb(0xff_ffffff)
GRAY = Gosu::Color.argb(0xff_808080)
LIGHT_GRAY = Gosu::Color.argb(0xff_cccccc)
BLACK = Gosu::Color.argb(0xff_000000)

class Overworld < Interface
  TOP_MARGIN = 120
  BOTTOM_MARGIN = 80

  def initialize location
    $state[:location] = location.key
    @location = location
    @map_offset_x = Map.offset(location.location[0])
    @map_offset_y = Map.offset(location.location[1])
    set_locations
    location.set_background
    @background = $backgrounds[location.key]
    @info_one = Gosu::Image.from_text($adventurer.status, 30)
    @info_two = Gosu::Image.from_text('Where do you want to travel?', 30)
    @far_locations_draw ||= @far_locations.map do |town|
      pin = "• #{town.name}"
      image = Gosu::Image.from_text(pin, INACTIVE_SIZE)
      [town, image]
    end

    @selected_option = @near_locations.index location
    setup_input_handling
    set_actions
  end

  def towns_and_dungeons
    $state[:towns].values + $state[:dungeons].values
  end

  def max_travel
    @max_travel ||= 350 + 200 * $adventurer.survival
  end

  def set_locations
    @far_locations = []
    @near_locations = []
    towns_and_dungeons.each do |location|
      next unless on_map? location
      if Distance.between(location.location, @location.location) <= max_travel
        @near_locations << location
      else
        @far_locations << location
      end
    end
  end

  def on_map? location
    y = location.long - @map_offset_y + TOP_MARGIN
    return false if y < TOP_MARGIN
    return false if y > (WINDOW_SIZE - BOTTOM_MARGIN)
    x = location.lat - @map_offset_x
    return false if x < 0
    return false if x > WINDOW_SIZE
    return true
  end

  def options
    @near_locations
  end

  def set_actions
    @near_locations.each do |town|
      define_singleton_method(town.key) do
        destroy
        TravelActions.set_off_to(town)
      end
    end
  end

  ACTIVE_SIZE = 30
  INACTIVE_SIZE = 20
  def draw
    @background.draw 0, TOP_MARGIN, 0
    selected_town = @near_locations[@selected_option]
    Gosu::Image.from_text(selected_town.description, 40).draw 10, 1380, 0
    @far_locations_draw.each do |town, label|
      town_y = town.long - @map_offset_y + TOP_MARGIN
      label.draw town.lat - @map_offset_x, town_y, 2, 1, 1, LIGHT_GRAY
      label.draw town.lat - @map_offset_x + 1, town_y + 1, 1, 1, 1, BLACK
    end

    @near_locations.each.with_index do |town, i|
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
      town_y = town.long - @map_offset_y + TOP_MARGIN
      # label
      Gosu::Image.from_text(pin, ACTIVE_SIZE, style).draw town.lat - @map_offset_x, town_y, z_index + 1, 1, 1, color
      # shadow
      Gosu::Image.from_text(pin, ACTIVE_SIZE, style).draw town.lat - @map_offset_x + 2, town_y + 2, z_index, 1, 1, BLACK
    end

    super
  end

  def take_action
    selected_action = @near_locations[@selected_option].key
    send selected_action
  end
end
