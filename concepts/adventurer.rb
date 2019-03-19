class Adventurer
  attr_accessor :name, :life, :money, :skillset

  def initialize name
    @name = name
    @life = 20
    @money = 10
  end
end
