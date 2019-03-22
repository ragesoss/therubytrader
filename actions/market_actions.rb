require_relative './action'

class MarketActions < Action
  def self.buy good, market
    price = market.price good
    if $adventurer.can_afford?(price) && market.available?(good)
      $adventurer.inventory.add good, 1
      $adventurer.pay price
      market.remove good, 1 
      return success
    else
      return failure
    end
  end

  def self.sell good, market
    price = market.sell_price good
    if $adventurer.inventory.goods[good] > 0
      $adventurer.inventory.remove good, 1
      $adventurer.get_paid price
      market.add good, 1
      return success
    else
      return failure
    end
  end
end
