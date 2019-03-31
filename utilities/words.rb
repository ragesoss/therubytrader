class Words
  def self.comma_list strings
    return strings.first if strings.length == 1

    strings[0..-2].join(', ') << " and " << strings[-1]
  end

  def self.classname symbol
    symbol.to_s.split('_').map { |word| word.capitalize }.join
  end

  def self.symbol klass
    klass.to_s
      .gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr("-", "_")
      .downcase
  end
end