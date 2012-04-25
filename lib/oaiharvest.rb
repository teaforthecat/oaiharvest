require "oaiharvest/version"
require "httparty"

Dir[File.dirname(__FILE__) + '/oaiharvest/*.rb'].each do |file|
  require file
end

module Oaiharvest
  # Your code goes here...
end
