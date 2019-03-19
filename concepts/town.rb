class Town
  attr_accessor :name, :population
  def initialize name, population: nil
    @name = name
    @population = population || rand(2000)
  end

  def describe
    "You're in #{name}, a town of #{population}."
  end
end
