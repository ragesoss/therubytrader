require_relative '../quest'

class Ascend < Quest
  def requirements_met?
    $adventurer.inventory.goods[:rubies] >= 100
  end

  def options
    return {} unless requirements_met?
    { complete: "Use your horde of rubies to ascend into immortality." }
  end

  def complete
    $state[:towns][place].quests -= [self]
    "You have ascended!"
  end
end