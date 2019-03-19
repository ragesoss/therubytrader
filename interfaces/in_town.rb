class InTown < Interface
  def initialize town, options = {}
    @town = town
    if options[:greeting]
      @greeting = Gosu::Image.from_text(options[:greeting], 30)
    end
    @description = Gosu::Image.from_text(@town.describe, 30)
    pp $state
  end

  def update
  end

  def draw
    @greeting&.draw 10, 10, 0
    @description.draw 10, 50, 0
  end
end
