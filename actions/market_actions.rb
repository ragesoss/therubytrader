require_relative './action'

class MarketActions < Action
  def self.buy good, market, max = false
    price = market.price good
    if !$adventurer.can_afford?(price)
      return failure("Sorry, you don't have enough #{MONEY}.")
    elsif !market.available?(good)
      return failure("Sorry, there's nothing left to buy.")
    elsif $adventurer.encumbered?
      return failure("You're carrying too much already!")
    else
      count = max ? max_buyable(good, market, price) : 1
      $adventurer.inventory.add good, count
      $adventurer.pay(price*count)
      market.remove good, count
      $adventurer.get_paid(1) if $adventurer.has? :bad_penny
      return success
    end
  end

  def self.max_buyable good, market, price
    affordable = $adventurer.money / price
    available = market.quantity good
    carryable = $adventurer.carrying_capacity / market.weight(good)
    [affordable, available, carryable].min
  end

  def self.sell good, market, max = false
    price = market.sell_price good
    return failure if $adventurer.inventory.goods[good] <= 0

    count = max ? $adventurer.inventory.goods[good] : 1
    $adventurer.inventory.remove good, count
    $adventurer.get_paid(price*count)
    market.add good, count
    return success
  end
end
