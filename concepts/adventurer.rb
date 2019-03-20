require_relative './inventory'
class Adventurer
  attr_accessor :name, :life, :money, :skillset, :inventory

  def initialize name
    @name = name
    @max_life = 20
    @life = 20
    @money = 100
    @inventory = Inventory.new(Hash.new 0)
  end

  def heal!
    @life = @max_life
  end

  def can_afford? cost
    money >= cost
  end

  def pay cost
    @money -= cost
  end

  def get_paid amount
    @money += amount
  end
end
