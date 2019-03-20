class MarketActions
  def self.buy good, market
    price = market.send(good)[:price]
    if $adventurer.money >= price
      $adventurer.inventory.add(good, 1)
      $adventurer.money -= price
      market.remove(good, 1)
      return Success.new
    else
      return Failure.new
    end
  end

  def self.sell good, market
    price = market.send(good)[:price]
    if $adventurer.inventory.goods[good] > 0
      $adventurer.inventory.remove(good, 1)
      $adventurer.money += price
      market.add(good, 1)
      return Success.new
    else
      return Failure.new
    end
  end

  class Success
    def success?
      true
    end
  end
  class Failure
    def success?
      false
    end
  end
end
