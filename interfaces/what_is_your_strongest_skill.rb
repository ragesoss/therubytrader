require_relative '../concepts/skills'
require_relative '../concepts/skillset'
require_relative '../concepts/town'
require_relative '../concepts/money'
require_relative '../interfaces/in_town'


class WhatIsYourStrongestSkill < Interface
  def initialize
    setup_input_handling
    @label = Gosu::Image.from_text('What is your strongest skill?', 30)
    @selected_skill_index = 0
    @options = []
  end

  def setup_input_handling
    @input = Gosu::TextInput.new
    $window.text_input = @input

    set_button_down do |id|
      case id
      when Gosu::KB_DOWN
        @selected_skill_index = (@selected_skill_index + 1) % SKILLS.length
      when Gosu::KB_UP
        @selected_skill_index = (@selected_skill_index - 1) % SKILLS.length
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        $adventurer.skillset = Skillset.new SKILLS[@selected_skill_index]
        unset_button_down
        destroy
        InTown.new(Town.new('Flossvale'), { greeting: welcome_message }).create
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

  def welcome_message
    "Wecome to the world, #{$adventurer.name}! You have #{$adventurer.life} life. You have #{$adventurer.money} #{MONEY}."
  end
end
