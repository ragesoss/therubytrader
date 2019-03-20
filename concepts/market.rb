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
  GOODS.each { |good| attr_accessor good }
  attr_reader :town

  def initialize town
    @town = town
    populate
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
