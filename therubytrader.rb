require 'gosu'
require_relative 'interfaces/what_is_your_name'

class MainScreen < Gosu::Window
  attr_accessor :on_button_down

  def initialize
    super 800, 800
    self.caption = 'The Ruby Trader'
    @elements = []
  end

  def turn_on!
    WhatIsYourName.new.create
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
end

# State the game and set the global state
$state = {}
$window = MainScreen.new
$window.turn_on!  # main screen turn on!
$window.show
