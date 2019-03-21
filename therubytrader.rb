require 'gosu'

require_relative 'interfaces/what_is_your_name'

class MainScreen < Gosu::Window
  attr_accessor :on_button_down

  def initialize
    super 1024, 1024
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

  def close
    File.write 'save_file', Marshal.dump($state)
    close!
  end
end

# State the game and set the global state
$window = MainScreen.new

if File.exist? 'save_file'
  $state = Marshal.load File.read 'save_file'
  $adventurer = $state[:adventurer]
  location = $state[:towns][$state[:location]]
  InTown.new(location).create
else
  $state = {}
  $window.turn_on! # main screen turn on!
end

$window.show
