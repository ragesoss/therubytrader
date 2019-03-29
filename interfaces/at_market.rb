require_relative '../actions/market_actions'

class AtMarket < Interface
  attr_reader :town
  def initialize town
    @town = town
    @background = Gosu::Image.new('media/merchant.png')
    update_greeting
    @description = Gosu::Image.from_text(description, 30)
    shop
    setup_input_handling
  end

  def description
    "You're in the #{town.name} market."
  end

  def draw
    @background.draw 800, 100, 0
    @greeting&.draw 10, 10, 0
    @description.draw 10, 50, 0
    @prompt&.draw 10, 90, 0
    @result&.draw 10, 640, 0
    @options.each.with_index do |option, i|
      style = @selected_option == i ? { bold: true, width: 600 } : { width: 600 }
      Gosu::Image.from_text(option[1], 30, style).draw 50, 160 + 60*i, 0
    end
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

  def shop
    @result = nil
    @prompt = nil
    @selected_option = 0
    @options = SHOP_ACTIONS
  end

  def buy_goods selected_option = 0
    @prompt = Gosu::Image.from_text('What would you like to buy?', 30)
    @selected_option = selected_option
    @options = town.market.buy_options
  end

  def sell_goods selected_option = 0
    @prompt = Gosu::Image.from_text('What would you like to sell?', 30)
    @selected_option = selected_option
    @options = town.market.sell_options
  end

  Market::GOODS.each do |good|
    define_method("buy_#{good}") { buy good }
    define_method("sell_#{good}") { sell good }
  end

  def buy good
    result = MarketActions.buy good, town.market
    if result.success?
      @result = Gosu::Image.from_text("You have #{$adventurer.money} #{MONEY} left.", 30)
    else
      @result = Gosu::Image.from_text(result.text, 30)
    end
    update_greeting
    buy_goods @selected_option # regenerates the options
  end

  def sell good
    result = MarketActions.sell good, town.market
    if result.success?
      @result = Gosu::Image.from_text("Sold! You have #{$adventurer.money} #{MONEY}.", 30)
    else
      @result = Gosu::Image.from_text("You don't have any #{good} to sell.", 30)
    end
    update_greeting
    sell_goods @selected_option # regenerates the options
  end

  def leave_shop
    unset_button_down
    destroy
    InTown.new(town).create
  end

  def take_action
    selected_action = @options.keys[@selected_option]
    send selected_action
  end

  def setup_input_handling
    set_button_down do |id|
      case id
      when Gosu::KB_DOWN
        @selected_option = (@selected_option + 1) % @options.length
      when Gosu::KB_UP
        @selected_option = (@selected_option - 1) % @options.length
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        take_action
      end
    end
  end
end
