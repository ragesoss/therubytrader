class InDungeon < Interface
  def initialize dungeon
    @dungeon = dungeon
    @level = 0
    @info_one = Gosu::Image.from_text("You have entered the dungeon of #{@dungeon.name}, which has #{monsters_list}.", 30, { width: 1000 })
    @options = {
      fight: 'Delve into the dungeon',
      flee: 'Flee'
    }
    @selected_option = 0
    setup_input_handling
  end

  def fight
    # Implement dungeon sequence to turn this into a series of encounters
  end

  def flee
    destroy
    TravelActions.return_from @dungeon
  end

  def monsters_list
    monsters = @dungeon.monsters[@level..-1].map do |monster|
      monster.name
    end
    Words.comma_list(monsters)
  end

  def draw
    super
    render_options_hash
  end
end