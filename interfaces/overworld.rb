require_relative '../actions/travel_actions'

class Overworld < Interface
  def initialize location
    $state[:location] = location.key
    @location = location
    @background = Gosu::Image.new('media/overworld.png')
    @greeting = Gosu::Image.from_text($adventurer.status, 30)
    @prompt = Gosu::Image.from_text('Where do you want to travel?', 30)
    @selected_option = towns.index location
    setup_input_handling
    set_actions
  end

  TOWN_NAMES = %w[Flossvale Chard Juniper Palmatum Sessa Scond Quercus]
  def towns
    @towns ||= TOWN_NAMES.map do |town_name|
      $state[:towns][town_name.downcase.to_sym] ||= Town.new(town_name)
    end
  end

  def set_actions
   towns.each do |town|
      define_singleton_method(town.key) do
        destroy
        TravelActions.set_off_to(town)
      end
    end
  end

  def update
  end

  def draw
    @background.draw 0, 0, 0, 0.5, 0.5
    @greeting.draw 10, 10, 0
    towns.each.with_index do |town, i|
      selected = @selected_option == i
      style = selected ? { bold: true } : {}
      z_index = selected ? 3 : 1
      size = 30
      pin = "• #{town.name}"
      color = if town == @location
                Gosu::Color.argb(0xff_ffd972)
              elsif selected
                Gosu::Color.argb(0xff_ffffff)
              else
                Gosu::Color.argb(0xff_808080)
              end
      # label
      Gosu::Image.from_text(pin, size, style).draw town.lat, town.long, z_index + 1, 1, 1, color
      # shadow
      Gosu::Image.from_text(pin, size, style).draw town.lat + 2, town.long + 2, z_index, 1, 1, Gosu::Color.argb(0xff_000000)
    end
  end

  def take_action
    selected_action = towns[@selected_option].key
    send selected_action
  end

  def setup_input_handling
    set_button_down do |id|
      case id
      when Gosu::KB_DOWN
        @selected_option = (@selected_option + 1) % towns.length
      when Gosu::KB_UP
        @selected_option = (@selected_option - 1) % towns.length
      when Gosu::KB_S
        pp $state
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        take_action
      end
    end
  end
end
