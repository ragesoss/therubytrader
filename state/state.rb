require_relative '../interfaces/start'
require_relative '../utilities/town_placer'
require_relative './background'

class State
  def self.start
    $backgrounds = {}
    Start.new.create
  end

  def self.location
    $state[:towns][$state[:location]]
  end

  def self.load_save save_file
    $state = Marshal.load File.read "saves/#{save_file}"
    $adventurer = $state[:adventurer]
    InTown.new(location).create
  end

  def self.destroy_save_file
    if File.exist? "saves/#{$adventurer.name}"
      File.delete "saves/#{$adventurer.name}"
    end
  end

  def self.save
    filename = $adventurer.name
    File.write "saves/#{filename}", Marshal.dump($state)
  end

  def self.save_files
    Dir['saves/*'].map { |f| f[6..] }
  end

  def self.hardcore?
    $state[:difficulty] == :hardcore
  end

  def self.join_background
    Background.join
  end

  def self.game_over!
    destroy_save_file if hardcore?
    $window.close!
  end
end
