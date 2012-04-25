# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "oaiharvest/version"

Gem::Specification.new do |s|
  s.name        = "oaiharvest"
  s.version     = Oaiharvest::VERSION
  s.authors     = ["Chris Thompson"]
  s.email       = ["chris.thompson@walkerart.org"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "oaiharvest"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "webmock"
  s.add_development_dependency "vcr"
  s.add_development_dependency "turn"
  s.add_development_dependency "rake"
  s.add_runtime_dependency "httparty"

end
