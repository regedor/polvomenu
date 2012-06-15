$:.push File.expand_path("../lib", __FILE__)
require 'polvomenu'

Gem::Specification.new do |s|
  # Metadata
  s.name        =  'polvomenu'
  s.version     =  Polvo::Menu::VERSION
  s.date        =  '2012-04-17'
  s.authors     =  ["Group Buddies"]
  s.email       =  ['regedor@groupbuddies.com','andrefs@cpan.org']
  s.homepage    =  'http://rubygems.org/gems/polvomenu'
  s.summary     =  "Directory-based command-line menu"
  s.description =  "Directory-based command-line menu "

  # Manifest
  s.files       =  Dir["{bin,lib}/**/*"] #+ ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables =  'polvomenu'
  # s.require_paths = ["lib"]

  # Dependencies
  s.add_dependency 'colorize'
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
