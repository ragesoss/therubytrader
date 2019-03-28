class Inventory
  attr_accessor :goods
  def initialize
    @goods = Hash.new 0
  end

  def weight
    goods.reduce(0) do |total, (good, count)|
      total + GOODS_TABLE[good][2] * count
    end
  end

  def add(good, quantity)
    goods[good] += quantity
  end

  def remove(good, quantity)
    goods[good] -= quantity
  end
end
