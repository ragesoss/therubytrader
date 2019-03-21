require 'gosu'
require_relative 'state/state'

class MainScreen < Gosu::Window
  attr_accessor :on_button_down

  def self.turn_on!
    $window = MainScreen.new
    State.start
    $window.show
  end

  def initialize
    super 1024, 1024
    self.caption = 'The Ruby Trader'
    @elements = []
  end

  def update
    @elements.each &:update
  end

  def draw
    @elements.each &:draw
  end

  def add_element element
    @elements += [element]
  end

  def remove_element element
    @elements -= [element]
  end

  def close
    State.save
    close!
  end
end

MainScreen.turn_on!
