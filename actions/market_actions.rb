require_relative './action'

class MarketActions < Action
  def self.buy good, market
    price = market.price good
    if !$adventurer.can_afford?(price)
      return failure("Sorry, you don't have enough #{MONEY}.")
    elsif !market.available?(good)
      return failure("Sorry, there's nothing left to buy.")
    elsif $adventurer.encumbered?
      return failure("You're carrying too much already!")
    else
      $adventurer.inventory.add good, 1
      $adventurer.pay price
      market.remove good, 1 
      return success
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
