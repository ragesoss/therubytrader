require_relative './action'

class InnActions < Action
  def self.rest cost
    if $adventurer.money >= cost
      $adventurer.money -= cost
      $adventurer.heal!
      return success
    else
      return failure
    end
  end
end
