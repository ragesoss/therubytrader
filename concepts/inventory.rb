class Inventory
  attr_accessor :goods
  def initialize
    @goods = Hash.new 0
  end

  def add(good, quantity)
    goods[good] += quantity
  end

  def remove(good, quantity)
    goods[good] -= quantity
  end
end
