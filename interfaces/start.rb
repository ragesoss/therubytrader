require_relative './interface'
require_relative './what_is_your_name'

class Start < Interface
  def initialize
    setup_input_handling
    @selected_option = 0
    @info_one = Gosu::Image.from_text('Choose a difficulty setting:', 30)
    @options = {
      normal: "Normal",
      hardcore: "Hardcore"
    }
  end

  def draw
    super
    render_options_hash
  end

  def normal
    @difficulty = :normal
    start_game
  end

  def hardcore
    @difficulty = :hardcore
    start_game
  end

  def start_game
    $state[:difficulty] = @difficulty
    unset_button_down
    destroy
    WhatIsYourName.new.create
  end
end