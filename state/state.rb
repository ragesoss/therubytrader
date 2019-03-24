require_relative '../interfaces/what_is_your_name'
require_relative '../utilities/town_placer'

class State
  def self.start
    if File.exist? 'save_file'
      load_save
      InTown.new(location).create
    else
      $state = {}
      TownPlacer.generate_towns
      WhatIsYourName.new.create
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
end
