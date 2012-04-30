class String
# File activesupport/lib/active_support/inflector/methods.rb, line 76
    def underscore()
      word = self.dup
      word.gsub!(/::/, '/')
      # word.gsub!(/(?:([A-Za-z\d])|^)(#{inflections.acronym_regex})(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
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
        string = string.sub(/^[a-z\d]*/) { inflections.acronyms[$&] || $&.capitalize }
      else
        # string = string.sub(/^(?:#{inflections.acronym_regex}(?=\b|[A-Z_])|\w)/) { $&.downcase }
      end
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end

end
