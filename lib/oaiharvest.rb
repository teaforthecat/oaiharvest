require "oaiharvest/version"
require "httparty"

module Oaiharvest
  module StringSupport
    def camelize(str, uppercase_first_letter = true)
      string = str.to_s
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      end
      string.gsub(/(?:_|(\/))([a-z\d]*)/){ "#{$1}#{$2.capitalize}" }.gsub('/', '::')
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

    def deWrap str
      str.gsub(/Wrap$/,'')
    end

    def is_excessive element
      element.name.match(/Wrap$|Set$/)
    end
  end

  module HashSupport
    def accumulate obj, key ,value
      if obj.class == Hash
        if hash.include?(key)
          hash[key] << value
        else
          hash[key] = value
        end
      elsif obj.respond_to?(key)
        if obj.send(key).nil? || obj.send(key).empty?
          obj.send("#{key}=", value)
        elsif obj.send(key).class == Array
          obj.send("#{key}") << value
        end
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/oaiharvest/*.rb'].each do |file|
  require file
end

