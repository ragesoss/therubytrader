class Encounter < Interface
  attr_reader :destination, :distance_remaining

  def initialize destination, distance_remaining
    @destination = destination
    @distance_remaining = distance_remaining

    @description = Gosu::Image.from_text("#{distance_remaining} leagues from #{destination.name}, encounter a goblin!", 30)
    @options = {
      continue_on: "Continue the journey to #{destination.name}."
    }
    @selected_option = 0
    setup_input_handling
  end

  def update
  end

  def draw
    @description.draw 10, 50, 0
    @options.each.with_index do |option, i|
      style = @selected_option == i ? { bold: true } : {}
      Gosu::Image.from_text(option[1], 30, style).draw 50, 160 + 50*i, 0
    end
  end

  def continue_on
    unset_button_down
    destroy
    TravelActions.continue_on_to destination, distance_remaining
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
