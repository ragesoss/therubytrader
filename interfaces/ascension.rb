class Ascension < Interface
  def initialize
    @message = Gosu::Image.from_text('You have ascended!', 60)
  end

  def draw
    @message.draw 10, 10, 0
  end
end