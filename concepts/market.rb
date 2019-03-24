require_relative './goods_table'
class Market
  GOODS = GOODS_TABLE.keys
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

  def sell_price good
    spread_rate = (100 - 10 + $adventurer.streetwise) / 100.0
    (price(good) * spread_rate).round
  end

  def buy_options
    options = []
    GOODS.each do |good|
      next unless available? good
      price = price good
      quantity = send(good)[:quantity]
      options << ["buy_#{good}", "#{good}: #{price} cp (#{quantity} available)"]
    end
    options << [:shop, "Done buying"]
    options.to_h
  end

  def sell_options
    GOODS.to_h do |good|
      price = sell_price good
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
      price = generate_price good
      quantity = generate_quantity price
      instance_variable_set "@#{good}", { price: price, quantity: quantity }
    end
  end

  def generate_price good
    base_price = GOODS_TABLE[good][0]
    [base_price * (1 + rand - rand), 1].max.to_i
  end

  def generate_quantity price
    divisor = [price, 6].max
    (rand(town.population) / (divisor / 3.0) * (1 - rand)).to_i
  end
end
