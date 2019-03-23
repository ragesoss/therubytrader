class Words
  def self.comma_list strings
    strings[0..-2].join(', ') << " and " << strings[-1]
  end
end