# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "omnistruct"
  s.version     = "1.0.0"

  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joshua Mervine"]
  s.email       = ["joshua@mervine.net"]
  s.homepage    = "https://github.com/jmervine/omnistruct"
  s.license     = 'MIT'

  s.summary     = "OmniStruct: Struct Utilities"
  s.description = s.summary + " -- Helpers for ClassyStruct, OpenStruct and Struct"

  s.add_runtime_dependency "classy_struct", "~> 0.3", ">= 0.3.2"
  s.add_development_dependency "minitest", "~> 5.4", ">= 5.4.3"

  s.files        = Dir.glob("*.rb") + %w(README.md)
  s.require_path = "."
end
