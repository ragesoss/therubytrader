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
      @status = Gosu::Image.from_text("You have have died!", 30)
    elsif @enemy.alive?
      @status = Gosu::Image.from_text("You have #{$adventurer.life} life. The enemy has #{@enemy.life} life.", 30)
    else
      @status = Gosu::Image.from_text("You have #{$adventurer.life} life, and the enemy is dead.", 30)
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
    @description.draw 10, 50, 0
    @status.draw 10, 100, 0
    @enemy.image&.draw 800, 100, 0
    @result&.draw 10, 640, 0
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

  def end_game
    State.destroy_save_file
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
