require 'gosu'
require_relative 'turn_on/turn_on'

class MainScreen < Gosu::Window
  include TurnOn

  def initialize
    super 800, 800
    self.caption = 'The Ruby Trader'
    @elements = [self.turn_on(self)] # main screen turn on!
  end

  def update
    @elements.each &:update
  end

  def draw
    @elements.each &:draw
  end
end

MainScreen.new.show
