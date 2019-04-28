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
    setup_input_handling
  end

  def fight
    destroy
    callback = Proc.new { enter_level(@level + 1) }
    Encounter.new(destination: @dungeon, callback: callback, enemy: monsters.first).create
  end

  def flee
    destroy
    TravelActions.return_from @dungeon
  end

  def monsters
    @dungeon.monsters[(@level-1)..-1]
  end

  def monsters_list
    monster_names = monsters.map do |monster|
      monster.name
    end
    Words.comma_list(monster_names)
  end

  def draw
    super
    render_options_hash
  end
end