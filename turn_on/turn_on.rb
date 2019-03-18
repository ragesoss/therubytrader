module TurnOn
  def turn_on window
    WhatIsYourName.new window
  end
end

class WhatIsYourName
  def initialize window
    @input = Gosu::TextInput.new
    window.text_input = @input
    @label = Gosu::Image.from_text('What is your name, adventurer?', 30)
    @output = Gosu::Image.from_text(String.new, 40)
  end

  def update
    @output = Gosu::Image.from_text(@input.text, 40)
  end

  def draw
    @label.draw 10, 10, 0
    @output.draw 50, 50, 0
  end
end
