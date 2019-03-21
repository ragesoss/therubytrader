require_relative './action'

class TravelActions < Action
  def self.set_off to:
    InTown.new(to).create
  end
end
