require_relative './skills'

class Skillset
  attr_accessor :skills
  def initialize top_skill
    @skills = {}
    SKILLS.each do |skill|
      @skills[skill] = 1
      next unless top_skill == skill
      @skills[skill] += 2
    end
  end
end
