require_relative './interface'
require_relative '../concepts/adventurer'
require_relative './what_is_your_strongest_skill'

class WhatIsYourName < Interface
  def initialize
    setup_input_handling
    @label = Gosu::Image.from_text('What is your name, adventurer?', 30)
    @output = Gosu::Image.from_text(String.new, 40)
  end

  def setup_input_handling
    @input = Gosu::TextInput.new
    $window.text_input = @input

    set_button_down do |id|
      case id
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        next if @input.text.empty?
        accept_player_name
      end
    end
  end

  def accept_player_name
    $state[:adventurer] = Adventurer.new @input.text
    $adventurer = $state[:adventurer]
    unset_button_down
    destroy
    WhatIsYourStrongestSkill.new.create
  end

  def update
    @output = Gosu::Image.from_text(@input.text, 40)
  end

  def draw
    @label.draw 10, 10, 0
    @output.draw 50, 50, 0
  end
end
