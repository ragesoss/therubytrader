class Inventory
  attr_accessor :goods
  def initialize goods
    @goods = goods
  end

  def add(good, quantity)
    goods[good] += quantity
  end

  def remove(good, quantity)
    goods[good] -= quantity
  end
end
