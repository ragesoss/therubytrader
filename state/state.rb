require_relative '../interfaces/what_is_your_name'

class State
  def self.start
    if File.exist? 'save_file'
      load_save
      InTown.new(location).create
    else
      $state = {}
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

  def self.save
    File.write 'save_file', Marshal.dump($state)
  end
end
