require "oaiharvest/version"
require "httparty"

module Oaiharvest
  module StringSupport
    def camelize(str, uppercase_first_letter = true)
      if uppercase_first_letter
        str = str.sub(/^[a-z\d]*/) { $&.capitalize }
      end
      str.gsub(/(?:_|(\/))([a-z\d]*)/){ "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end

    def underscore(str)
      word = str.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end

Dir[File.dirname(__FILE__) + '/oaiharvest/*.rb'].each do |file|
  require file
end

