class InDungeon < Interface
  def initialize dungeon
    @dungeon = dungeon
    @message = Gosu::Image.from_text("You have entered the dungeon of #{@dungeon.name}, but there's no way out.", 60, { width: 1000 })
  end

  def draw
    @message.draw 10, 10, 0
  end
end