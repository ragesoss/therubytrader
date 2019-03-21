class Overworld < Interface
  def initialize location
    $state[:location] = location.key
    @background = Gosu::Image.new('media/overworld.png')
    @greeting = Gosu::Image.from_text($adventurer.status, 30)
    @prompt = Gosu::Image.from_text('Where do you want to travel?', 30)
    pp location
    pp towns
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
        InTown.new($state[:towns][town.key]).create
      end
    end
  end

  def update
  end

  def draw
    @background.draw 0, 0, 0, 0.5, 0.5
    @greeting.draw 10, 10, 0
    towns.each.with_index do |town, i|
      style = @selected_option == i ? { bold: true } : {}
      pin = "• #{town.name}"
      # label
      Gosu::Image.from_text(pin, 30, style).draw town.lat, town.long, 2
      # shadow
      Gosu::Image.from_text(pin, 30, style).draw town.lat + 2, town.long + 2, 1, 1, 1, Gosu::Color.argb(0xff_000000)
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
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        take_action
      end
    end
  end
end
