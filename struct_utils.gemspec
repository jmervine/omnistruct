Gem::Specification.new do |s|
  s.name        = "struct_utils"
  s.version     = "0.0.1"
  s.date        = "2014-12-11"
  s.summary     = "Utils for Struct, OpenStruct and/or ClassyStruct."
  s.description = "Utils for Struct, OpenStruct and/or ClassyStruct."
  s.authors     = ["Joshua P. Mervine"]
  s.email       = "joshua@mervine.net"
  s.files       = ["struct_utils.rb"]
  s.homepage    =
    "https://github.com/jmervine/struct_utils"
  s.license       = "MIT"

  s.add_runtime_dependency "classy_struct", "~> 0.3", ">= 0.3.2"
  s.add_development_dependency "minitest", "~> 5.4", ">= 5.4.3"
end
