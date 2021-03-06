require_relative './action'
require_relative '../interfaces/encounter'
require_relative '../utilities/distance'

class TravelActions < Action
  def self.set_off_to destination
    total_distance = distance_to destination
    continue_on_to destination, total_distance
  end

  def self.return_from location
    total_distance = distance_to location
    continue_on_to State.location, total_distance
  end

  def self.continue_on_to destination, distance_remaining
    if distance_remaining == 0
      destination.enter
    else
      move_closer(destination, distance_remaining) { return }
      continue_on_to destination, distance_remaining - 1
    end
  end

  def self.move_closer destination, distance_remaining
    # chance of encounter
    return unless rand(200) == 1

    callback = Proc.new { continue_on_to destination, distance_remaining }
    Encounter.new(destination: destination, distance_remaining: distance_remaining, callback: callback).create
    yield
  end

  def self.distance_to location
    Distance.between State.location.location, location.location
  end
end
