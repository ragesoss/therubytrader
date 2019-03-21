require_relative './action'
require_relative '../interfaces/encounter'

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
    distance State.location.location, location.location
  end

  def self.distance point_one, point_two
    Math.sqrt(
      (point_one[0] - point_two[0])**2 + (point_one[1] - point_two[1])**2
    ).round
  end
end
