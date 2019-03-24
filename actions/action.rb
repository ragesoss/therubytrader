class Action
  def self.success text = nil
    Success.new text
  end

  def self.failure text = nil
    Failure.new text
  end

  class Result
    attr_reader :text
    def initialize text
      @text = text
    end
  end

  class Success < Result
    def success?
      true
    end
  end

  class Failure < Result
    def success?
      false
    end
  end
end
