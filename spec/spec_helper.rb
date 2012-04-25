#we need the actual library file
require_relative '../lib/oaiharvest'
# For Ruby < 1.9.3, use this instead of require_relative
# require(File.expand_path('../../lib/dish', __FILE__))
 
#dependencies
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'turn'
require 'debugger'

Turn.config do |c|
  c.format  = :outline
  c.verbose  = false
  c.natural = true
  c.ansi = true
end
 
#VCR config
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/oaiharvest_cassettes'
  c.hook_into :webmock
end
