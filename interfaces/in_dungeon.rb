class InDungeon < Interface
  def initialize dungeon
    @dungeon = dungeon
    @level = 1
    @info_one = Gosu::Image.from_text("You have entered the dungeon of #{@dungeon.name}, which has #{monsters_list}.", 30, { width: 1200 })
    @options = {
      fight: 'Delve into the dungeon',
      flee: 'Flee'
    }
    @selected_option = 0
    setup_input_handling
  end

  def enter_level level
    @level = level
    @info_one = Gosu::Image.from_text("You've made your way to level #{level} of #{@dungeon.name}, which still has #{monsters_list}.", 30, { width: 1000 })
    create
  end

  def fight
    destroy
    enter_level(@level + 1)
  end

  def flee
    destroy
    TravelActions.return_from @dungeon
  end

  def monsters_list
    monsters = @dungeon.monsters[(@level-1)..-1].map do |monster|
      monster.name
    end
    Words.comma_list(monsters)
  end

  def draw
    super
    render_options_hash
  end
end