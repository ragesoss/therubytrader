
MONEY = 'rubies'

def get_player_name
  puts 'What is your name, adventurer?'
  name = $stdin.gets.chomp
  @adventurer = Adventurer.new(name)
end

SKILLS = {
  '1' => :survival,
  '2' =>  :stealth,
  '3' => :swordfighting,
  '4' => :streetwise
}
def choose_initial_skills
  puts 'What is your strongest skill?'
  SKILLS.each do |number, name|
    puts "#{number}: #{name}"
  end

  top_skill = $stdin.gets.chomp
  choose_initial_skills unless SKILLS.keys.include? top_skill
  @adventurer.skillset = Skillset.new(top_skill)
  puts "Your skills are"
  @adventurer.skillset.skills.each do |name, skill_level|
    puts "#{name}: #{skill_level}"
  end
end

def set_starting_location
  @location = Town.new 'Flossvale', 73
end

def welcome_to_the_world
  puts "Wecome to the world, #{@adventurer.name}! You have #{@adventurer.life} life. You have #{@adventurer.money} #{MONEY}."
  @location.describe
end

def start_game
  get_player_name
  choose_initial_skills
  set_starting_location
  welcome_to_the_world
  exit
end

class Adventurer
  attr_accessor :name, :life, :money, :skillset

  def initialize name
    @name = name
    @life = 20
    @money = 10
  end
end

class Skillset
  attr_accessor :skills
  def initialize top_skill
    @skills = {}
    SKILLS.each do |number, name|
      @skills[name] = 1
      next unless top_skill == number
      @skills[name] += 2
    end
  end
end


class Town
  attr_accessor :name, :population
  def initialize name, population
    @name = name
    @population = population
  end

  def describe
    puts "You're in #{name}, a town of #{population}."
  end

  def shop
  end
end

start_game
