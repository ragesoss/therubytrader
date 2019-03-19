class Inventory
  attr_accessor :goods
  def initialize goods
    @goods = goods
  end

  def add(good, quantity)
    if goods[good]
      goods[good] += quantity
    else
      goods[good] = quantity
    end
  end
end