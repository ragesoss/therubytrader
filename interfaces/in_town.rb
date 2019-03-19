class InTown < Interface
  def initialize
    @greeting = Gosu::Image.from_text('Welcome to town!', 30)
  end

  def update
  end

  def draw
    @greeting.draw 10, 10, 0
  end
end
