require_relative '../concepts/skills'

class WhatIsYourStrongestSkill < Interface
  def initialize
    @input = Gosu::TextInput.new
    $window.text_input = @input
    capture_enter
    @label = Gosu::Image.from_text('What is your strongest skill?', 30)
    @selected_skill_index = 0
    @options = []
  end

  def capture_enter
    set_button_down do |id|
      case id
      when Gosu::KB_DOWN
        @selected_skill_index = (@selected_skill_index + 1) % SKILLS.length
      when Gosu::KB_UP
        @selected_skill_index = (@selected_skill_index - 1) % SKILLS.length
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        $state[:strongest_skill] = SKILLS[@selected_skill_index]
        unset_button_down
        destroy
        pp $state
      end
    end
  end

  def update
    @output = Gosu::Image.from_text(@input.text, 40)
    @options = SKILLS.map.with_index do |skill, i|
      style = @selected_skill_index == i ? { bold: true } : {}
      Gosu::Image.from_text(skill, 40, style)
    end
  end

  def draw
    @label.draw 10, 10, 0
    @options.each.with_index do |option, i|
      option.draw 50, 50*(i+1), 0
    end
  end
end
