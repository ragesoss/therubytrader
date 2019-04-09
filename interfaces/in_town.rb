require_relative '../actions/market_actions'
require_relative '../actions/inn_actions'
require_relative './at_market'
require_relative './overworld'

class InTown < Interface
  attr_reader :town
  def initialize town, options = {}
    $state[:location] = town.key
    @town = town
    @quests = town.quests || []
    @background = Gosu::Image.new(town.image)
    update_greeting options[:greeting]
    @info_one = Gosu::Image.from_text(description, 30)
    set_overview
    setup_input_handling
    Background.threads << Thread.new { town.set_background }
  end

  def description
    "You're in #{town.description}."
  end

  def draw
    super
    @background.draw 800, 100, 0
    @result&.draw 10, 640, 0
    render_options_hash
  end

  def update_greeting greeting = nil
    if greeting
      @info_two = Gosu::Image.from_text(greeting, 30)
    else
      @info_two = Gosu::Image.from_text($adventurer.status, 30)
    end
  end

  OVERVIEW_ACTIONS = {
    shop: "Visit the market",
    rest: "Rest at the inn",
    talk: "Talk with the townsfolk",
    leave: "Travel on"
  }
  def set_overview result = nil
    @result = result
    @info_three = Gosu::Image.from_text('What will you do?', 30)
    @selected_option = 0
    @options = {}
    town.quests.each do |quest|
      next unless quest.show? self
      @options = @options.merge(quest.options)
      quest.options.keys.each do |action|
        define_singleton_method(action) do
          result = quest.send(action, self)
          set_overview Gosu::Image.from_text(result, 30)
        end
      end
    end
    @options.merge! OVERVIEW_ACTIONS
  end

  def rest
    result = InnActions.rest town.inn_cost
    if result.success?
      @result = Gosu::Image.from_text("You have #{$adventurer.money} #{MONEY} left. You're at full life.", 30)
    else
      @result = Gosu::Image.from_text("Sorry, you don't have enough #{MONEY}.", 30)
    end
    update_greeting
  end

  def shop
    unset_button_down
    destroy
    AtMarket.new(town).create
  end

  def talk
    @result = Gosu::Image.from_text("You chat with several passersby, but you learn nothing new.", 30)
  end

  def leave
    unset_button_down
    Background.join
    destroy
    Overworld.new(town).create
  end
end
