class Market
  GOODS = [
    :rubies,
    :wheat,
    :hide,
    :silver,
    :cloth,
    :tools,
    :relics,
    :food
  ]
  attr_accessor *GOODS
  attr_reader :town

  def initialize town
    @town = town
    populate
  end

  def price good
    send(good)[:price]
  end

  def qauntity good
    send(good)[:quantity]
  end

  def available? good
    send(good)[:quantity].positive?
  end

  def buy_options
    options = []
    GOODS.each do |good|
      next unless available? good
      price = send(good)[:price]
      quantity = send(good)[:quantity]
      options << ["buy_#{good}", "#{good}: #{price} cp (#{quantity} available)"]
    end
    options << [:shop, "Done buying"]
    options.to_h
  end

  def sell_options
    GOODS.to_h do |good|
      price = send(good)[:price]
      quantity = $adventurer.inventory.goods[good]
      ["sell_#{good}", "#{good}: #{price} cp (#{quantity} owned)"]
    end.merge({ shop: "Done selling" })
  end

  def add good, quantity
    instance_variable_get("@#{good}")[:quantity] += quantity
  end

  def remove good, quantity
    instance_variable_get("@#{good}")[:quantity] -= quantity
  end

  private

  def populate
    GOODS.each do |good|
      instance_variable_set "@#{good}", { price: generate_price, quantity: generate_quantity }
    end
  end

  def generate_price
    [rand(town.population) / 10, 1].max
  end

  def generate_quantity
    [rand(town.population) - 30, 0].max
  end
end
