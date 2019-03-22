require_relative './action'
require_relative '../interfaces/encounter'
require_relative '../utilities/distance'

class TravelActions < Action
  def self.set_off_to destination
    total_distance = distance_to destination
    continue_on_to destination, total_distance
  end

  def self.continue_on_to destination, remaining_distance
    if remaining_distance == 0
      InTown.new(destination).create
    else
      move_closer(destination, remaining_distance){ return }
      continue_on_to destination, remaining_distance - 1
    end
  end

  def self.move_closer destination, remaining_distance
    # chance of encounter
    return unless rand(200) == 1

    Encounter.new(destination, remaining_distance).create
    yield
  end

  def self.distance_to location
    Distance.between State.location.location, location.location
  end
end
