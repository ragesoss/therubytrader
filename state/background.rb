class Background
  def self.threads
    @threads ||= []
  end

  def self.join
    @threads.each(&:join)
    @threads = []
  end
end