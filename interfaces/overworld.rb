class Overworld < Interface
  def initialize location
    $state[:location] = location.key
    @background = Gosu::Image.new('media/overworld.png')
    @greeting = Gosu::Image.from_text($adventurer.status, 30)
    @prompt = Gosu::Image.from_text('Where do you want to travel?', 30)
    @options = {
      flossvale: '• Flossvale',
      foo: '• Foo',
      bar: '• Bar'
    }
    @selected_option = @options.keys.index location.key
    setup_input_handling
    set_actions
  end

  def set_actions
    @options.keys.each do |town_name|
      define_singleton_method(town_name) do
        $state[:towns][town_name] ||= Town.new(town_name.to_s.capitalize)
        destroy
        InTown.new($state[:towns][town_name]).create
      end
    end
  end

  def update
  end

  def draw
    @background.draw 0, 0, 0, 0.5, 0.5
    @greeting.draw 10, 10, 0
    @options.each.with_index do |option, i|
      style = @selected_option == i ? { bold: true } : {}
      Gosu::Image.from_text(option[1], 30, style).draw 50, 160 + 50*i, 1
    end
  end

  def take_action
    selected_action = @options.keys[@selected_option]
    send selected_action
  end

  def setup_input_handling
    set_button_down do |id|
      case id
      when Gosu::KB_DOWN
        @selected_option = (@selected_option + 1) % @options.length
      when Gosu::KB_UP
        @selected_option = (@selected_option - 1) % @options.length
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        take_action
      end
    end
  end
end
