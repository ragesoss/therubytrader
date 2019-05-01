require_relative '../actions/encounter_actions'

class Encounter < Interface
  attr_reader :destination, :distance_remaining

  def initialize destination: nil, distance_remaining: nil, enemy: nil, callback: nil
    @destination = destination
    @distance_remaining = distance_remaining

    @enemy = enemy || EncounterActions.pick_monster(@destination)
    @callback = callback

    @round = 1
    @info_one = Gosu::Image.from_text("#{distance_remaining} leagues from #{destination.name}, you encounter #{@enemy.name}!", 30)
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
      @info_two = Gosu::Image.from_text("You have have died!", 30)
    elsif @enemy.alive?
      @info_two = Gosu::Image.from_text("You have #{$adventurer.life} life. The enemy has #{@enemy.life} life.", 30)
    else
      @info_two = Gosu::Image.from_text("You have #{$adventurer.life} life, and the enemy is dead.", 30)
    end
  end

  def fight
    result = EncounterActions.fight @enemy, @round
    @result = Gosu::Image.from_text(result.text, 30)
    return set_victory if result.success?
    set_defeat if $adventurer.dead?
    update_status
    @round += 1
  end

  def run
    result = EncounterActions.run_from @enemy, @round
    set_escape if result.success?
    set_defeat if $adventurer.dead?
    update_status
    @round += 1
  end

  def draw
    super
    @enemy.image&.draw 800, 100, 0
    @result&.draw 10, 640, 0
    @end_result&.draw 10, 690, 00
    render_options_hash
  end

  def continue_on
    destroy
    @callback.call
  end

  def end_game
    State.game_over!
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
    @end_result = Gosu::Image.from_text("You defeated #{@enemy.specific_name}! Your foe had #{@enemy.loot}.", 30)
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
