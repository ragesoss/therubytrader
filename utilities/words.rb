class Words
  def self.comma_list strings
    return strings.first if strings.length == 1

    strings[0..-2].join(', ') << " and " << strings[-1]
  end
end