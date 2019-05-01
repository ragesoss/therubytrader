require_relative '../actions/market_actions'

class AtMarket < Interface
  attr_reader :town
  def initialize town
    @town = town
    @background = Gosu::Image.new('media/merchant.png')
    update_greeting
    @info_one = Gosu::Image.from_text(description, 30)
    @info_two = Gosu::Image.from_text($adventurer.status, 30)
    shop
    setup_input_handling
  end

  def max?
    @secondary_option_selected
  end

  def description
    "You're in the #{town.name} market."
  end

  def draw
    super
    @background.draw 800, 100, 0
    @result&.draw 10, 700, 0
    @options.each.with_index do |option, i|
      if @current_action == :menu
        text = option[1]
      elsif @options.count == i +1
        text = option[1]
      else
        text = "#{option[1]}#{transaction_count_label}"
      end
      style = @selected_option == i ? { bold: true, width: 800 } : { width: 800 }
      Gosu::Image.from_text(text, 30, style).draw 50, 160 + 60*i, 0
    end
  end

  def transaction_count_label
    if @current_action == :buying
      action = 'buy'
    else
      action = 'sell'
    end
    count = max? ? 'max' : '1'
    "  —  #{action} #{count}"
  end

  def update_greeting greeting = nil
    if greeting
      @greeting = Gosu::Image.from_text(greeting, 30)
    else
      @greeting = Gosu::Image.from_text($adventurer.status, 30)
    end
  end

  SHOP_ACTIONS = {
    buy_goods: "Buy goods",
    sell_goods: "Sell goods",
    leave_shop: "Leave"
  }

  def shop result = nil
    @current_action = :menu
    @result = result
    @info_three = nil
    @selected_option = 0

    @options = {}
    town.quests.each do |quest|
      next unless quest.show? self
      quest.possible_actions.each do |action|
        define_singleton_method(action) do
          result = quest.send(action, self)
          shop Gosu::Image.from_text(result.text, 30, width: 800)
        end
      end
      @options = @options.merge(quest.options)
    end
    @options.merge! SHOP_ACTIONS
  end

  def buy_goods selected_option = 0
    @current_action = :buying
    @info_three = Gosu::Image.from_text('What would you like to buy?', 30)
    @selected_option = selected_option
    @options = town.market.buy_options
  end

  def sell_goods selected_option = 0
    @current_action = :selling
    @info_three = Gosu::Image.from_text('What would you like to sell?', 30)
    @selected_option = selected_option
    @options = town.market.sell_options
  end

  Market::GOODS.each do |good|
    define_method("buy_#{good}") { buy good }
    define_method("sell_#{good}") { sell good }
  end

  def buy good
    result = MarketActions.buy good, town.market, max?
    if result.success?
      @result = Gosu::Image.from_text("You have #{$adventurer.money} #{MONEY} left.", 30)
    else
      @result = Gosu::Image.from_text(result.text, 30)
    end
    update_greeting
    buy_goods @selected_option # regenerates the options
  end

  def sell good
    result = MarketActions.sell good, town.market, max?
    if result.success?
      @result = Gosu::Image.from_text("Sold! You have #{$adventurer.money} #{MONEY}.", 30)
    else
      @result = Gosu::Image.from_text("You don't have any #{good} to sell.", 30)
    end
    update_greeting
    sell_goods @selected_option # regenerates the options
  end

  def leave_shop
    destroy
    InTown.new(town).create
  end
end
