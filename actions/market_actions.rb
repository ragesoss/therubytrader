class MarketActions
  def self.buy good, market
    $adventurer.inventory.add(good, 1)
    price = market.send(good)[:price]
    $adventurer.money -= price
    market.remove(good, 1)
  end
end