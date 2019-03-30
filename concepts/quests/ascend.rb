require_relative '../quest'
require_relative '../../interfaces/ascension'

class Ascend < Quest
  def show? interface
    interface.class == InTown
  end

  def possible_actions
    [:complete]
  end

  def requirements_met?
    $adventurer.inventory.goods[:rubies] >= 100
  end

  def options
    return {} unless requirements_met?
    { complete: "Use your horde of rubies to ascend into immortality." }
  end

  def complete interface
    $state[:towns][place].quests -= [self]
    interface.destroy
    Ascension.new.create
    "You have ascended!"
  end
end