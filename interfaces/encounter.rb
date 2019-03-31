require_relative '../actions/encounter_actions'

class Encounter < Interface
  attr_reader :destination, :distance_remaining

  def initialize destination, distance_remaining
    @destination = destination
    @distance_remaining = distance_remaining

    @enemy = EncounterActions.pick_monster(@destination)
    @description = Gosu::Image.from_text("#{distance_remaining} leagues from #{destination.name}, you encounter #{@enemy.name}!", 30)
    set_fight_options
    update_status
    @selected_option = 0
    setup_input_handling
  end

  def set_fight_options
    @options = {
      fight: "Fight",
      run: "Run!"
    }
  end

  def update
  end

  def update_status
    if $adventurer.dead?
      @prompt = Gosu::Image.from_text("You have have died!", 30)
    elsif @enemy.alive?
      @prompt = Gosu::Image.from_text("You have #{$adventurer.life} life. The enemy has #{@enemy.life} life.", 30)
    else
      @prompt = Gosu::Image.from_text("You have #{$adventurer.life} life, and the enemy is dead.", 30)
    end
  end

  def fight
    result = EncounterActions.fight @enemy
    @result = Gosu::Image.from_text(result.text, 30)
    return set_victory if result.success?
    set_defeat if $adventurer.dead?
    update_status
  end

  def run
    result = EncounterActions.run_from @enemy
    set_escape if result.success?
    set_defeat if $adventurer.dead?
    update_status
  end

  def draw
    super
    @enemy.image&.draw 800, 100, 0
    @result&.draw 10, 640, 0
    render_options_hash
  end

  def continue_on
    unset_button_down
    destroy
    TravelActions.continue_on_to destination, distance_remaining
  end

  def end_game
    State.destroy_save_file if State.hardcore?
    $window.close!
  end

  def set_escape
    @options = {
      continue_on: "You got away! Continue the journey to #{destination.name}."
    }
    @selected_option = 0
  end

  def set_victory
    EncounterActions.loot_body @enemy
    EncounterActions.gain_experience @enemy
    @status = Gosu::Image.from_text("You defeated #{@enemy.specific_name}! Your foe had #{@enemy.loot}.", 30)
    @options = {
      continue_on: "Continue the journey to #{destination.name}."
    }
    @selected_option = 0
  end

  def set_defeat
    @options = {
      end_game: "Your journey has ended."
    }
    @selected_option = 0
  end
end
