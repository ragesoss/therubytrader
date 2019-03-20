class Action
  def self.success
    Success.new
  end

  def self.failure
    Failure.new
  end

  class Success
    def success?
      true
    end
  end

  class Failure
    def success?
      false
    end
  end
end
