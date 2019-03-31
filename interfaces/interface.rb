require_relative '../input_handlers/keyboard_input'

class Interface
  include KeyboardInput
  attr_reader :options

  def update
  end

  def draw
    @greeting&.draw 10, 10, 0
    @description&.draw 10, 50, 0
    @prompt&.draw 10, 90, 0
  end

  def render_options_hash
    @options.each.with_index do |option, i|
      style = @selected_option == i ? { bold: true, width: 600 } : { width: 600 }
      Gosu::Image.from_text(option[1], 30, style).draw 50, 160 + 60*i, 0
    end
  end

  def create
    $window.add_element self
  end

  def destroy
    $window.remove_element self
  end

  def setup_input_handling
    set_button_down do |id|
      case id
      when Gosu::KB_S
        pp $state
      when Gosu::KB_LEFT
        decrement_secondary_option
      when Gosu::KB_RIGHT
        increment_secondary_option
      when Gosu::KB_DOWN
        @selected_option = (@selected_option + 1) % options.length
      when Gosu::KB_UP
        @selected_option = (@selected_option - 1) % options.length
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        take_action
      end
    end
  end

  def take_action
    selected_action = options.keys[@selected_option]
    send selected_action
  end

  def increment_main_option
    @selected_option = (@selected_option + 1) % options.length
  end

  def decrement_main_option
    @selected_option = (@selected_option - 1) % options.length
  end

  def increment_secondary_option
    @secondary_option_selected = !@secondary_option_selected
  end

  def decrement_secondary_option
    @secondary_option_selected = !@secondary_option_selected
  end
end
