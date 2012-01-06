# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "allowy/version"

Gem::Specification.new do |s|
  s.name        = "allowy"
  s.version     = Allowy::VERSION
  s.authors     = ["Dmytrii Nagirniak"]
  s.email       = ["dnagir@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "allowy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activesupport"

  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
end
