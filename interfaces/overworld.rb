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
    @background = Gosu::Image.new('media/overworld.png')
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

  TOWN_NAMES = %w[Chard Erycina Flossvale Govenia Garaya Holopogon Isotria
                  Juniper Lanium Macodes Mixis Mume Ophrys Orchedo Palmatum
                  Panisea Podangis Quercus Rana Risleya Salix Scond Sessa
                  Stenia Trias Vanda Yoania]
  def towns
    @towns ||= TOWN_NAMES.map do |town_name|
      $state[:towns][town_name.downcase.to_sym] ||= Town.new(town_name)
    end
  end

  def max_travel
    @max_travel ||= 250 + 100 * $adventurer.survival
  end

  def nearby_towns
    @nearby_towns ||= towns.select do |town|
      Distance.between(town.location, @location.location) <= max_travel
    end
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

  def update
  end

  ACTIVE_SIZE = 30
  INACTIVE_SIZE = 20
  def draw
    @background.draw 0, 0, 0, MAP_RATIO, MAP_RATIO
    @greeting.draw 10, 10, 0

    @far_towns_draw.each do |town, label|
      label.draw town.lat, town.long, 2, 1, 1, LIGHT_GRAY
      label.draw town.lat + 1, town.long + 1, 1, 1, 1, BLACK
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
      Gosu::Image.from_text(pin, ACTIVE_SIZE, style).draw town.lat, town.long, z_index + 1, 1, 1, color
      # shadow
      Gosu::Image.from_text(pin, ACTIVE_SIZE, style).draw town.lat + 2, town.long + 2, z_index, 1, 1, BLACK
    end
  end

  def take_action
    selected_action = nearby_towns[@selected_option].key
    send selected_action
  end

  def setup_input_handling
    set_button_down do |id|
      case id
      when Gosu::KB_DOWN
        @selected_option = (@selected_option + 1) % nearby_towns.length
      when Gosu::KB_UP
        @selected_option = (@selected_option - 1) % nearby_towns.length
      when Gosu::KB_S
        pp $state
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        take_action
      end
    end
  end
end
