require_relative './inventory'
class Adventurer
  attr_accessor :name, :life, :money, :skillset, :inventory

  def initialize name
    @name = name
    @life = 20
    @money = 10
    @inventory = Inventory.new({})
  end
end
