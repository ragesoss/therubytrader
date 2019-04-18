require_relative '../interfaces/start'
require_relative '../utilities/town_placer'
require_relative './background'

class State
  def self.start
    $backgrounds = {}
    if File.exist? 'save_file'
      load_save
      InTown.new(location).create
    else
      $state = {}
      Background.threads << Thread.new { TownPlacer.generate_towns }
      Background.threads << Thread.new { TownPlacer.generate_dungeons }
      Start.new.create
    end
  end

  def self.location
    $state[:towns][$state[:location]]
  end

  def self.load_save
    $state = Marshal.load File.read 'save_file'
    $adventurer = $state[:adventurer]
  end

  def self.destroy_save_file
    if File.exist? 'save_file'
      File.delete 'save_file'
    end
  end

  def self.save
    File.write 'save_file', Marshal.dump($state)
  end

  def self.hardcore?
    $state[:difficulty] == :hardcore
  end

  def self.join_background
    Background.join
  end
end
