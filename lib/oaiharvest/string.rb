class String
  # File activesupport/lib/active_support/inflector/methods.rb, line 76
  def underscore()
    word = self.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

  # File activesupport/lib/active_support/inflector/methods.rb, line 54
  def camelize( uppercase_first_letter = true)
    string = self.to_s
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end

end
