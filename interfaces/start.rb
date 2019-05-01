require_relative './interface'
require_relative './what_is_your_name'

class Start < Interface
  def initialize
    setup_input_handling
    @selected_option = 0
    @info_one = Gosu::Image.from_text('Welcome to The Ruby Trader! Choose your fate:', 30)
    @options = {
      normal: "New Game — Normal",
      hardcore: "New Game — Hardcore"
    }
    State.save_files.each do |save|
      define_singleton_method("load_#{save}") do
        destroy
        State.load_save save
      end
      @options["load_#{save}"] = "Load Saved Game — \"#{save}\""
    end
  end

  def draw
    super
    render_options_hash
  end

  def new_game
    $state = {}
    Background.threads << Thread.new { TownPlacer.generate_towns }
    Background.threads << Thread.new { TownPlacer.generate_dungeons }
  end

  def normal
    new_game
    $state[:difficulty] = :normal
    start_game
  end

  def hardcore
    new_game
    $state[:difficulty] = :hardcore
    start_game
  end

  def start_game
    destroy
    WhatIsYourName.new.create
  end
end