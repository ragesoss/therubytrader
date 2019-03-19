class InTown < Interface
  def initialize town, options = {}
    @town = town
    if options[:greeting]
      @greeting = Gosu::Image.from_text(options[:greeting], 30)
    end
    @description = Gosu::Image.from_text(@town.describe, 30)

    set_overview
    pp $state
  end

  def update
  end

  def draw
    @greeting&.draw 10, 10, 0
    @description.draw 10, 50, 0
    @options.each.with_index do |option, i|
      style = @selected_option_index == i ? { bold: true } : {}
      Gosu::Image.from_text(option[1], 30, style).draw 50, 120 + 50*i, 0
    end
  end

  OVERVIEW_ACTIONS = {
    rest: "Rest at the inn",
    shop: "Visit the market",
    talk: "Talk with the townsfolk",
    leave: "Travel on"
  }
  def set_overview
    @selected_option_index = 0
    @options = OVERVIEW_ACTIONS
    setup_input_handling
  end

  def rest
    puts 'resting'
  end

  def shop
    puts 'shopping'
  end

  def talk
    puts 'talking'
  end

  def leave
    puts 'leaving'
  end

  def take_action
    selected_option = @options.keys[@selected_option_index]
    send selected_option
  end

  def setup_input_handling
    set_button_down do |id|
      case id
      when Gosu::KB_DOWN
        @selected_option_index = (@selected_option_index + 1) % @options.length
      when Gosu::KB_UP
        @selected_option_index = (@selected_option_index - 1) % @options.length
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        take_action
      end
    end
  end
end
