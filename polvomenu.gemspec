$:.push File.expand_path("../lib", __FILE__)
require 'polvo'

Gem::Specification.new do |gem|
  gem.name        =  'polvomenu'
  gem.version     =  Polvo::VERSION
  gem.date        =  '2012-04-17'
  gem.summary     =  "Directory-based command-line menu"
  gem.description =  "Directory-based command-line menu "
  gem.authors     =  ["Miguel Regedor","André Santos","Group Buddies"]
  gem.email       =  'regedor@groupbuddies.com'
  gem.executables << 'polvomenu'
  gem.files       =  Dir["{bin,lib}/**/*"] #+ ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  gem.homepage    =  'http://rubygems.org/gems/polvomenu'

  gem.add_dependency 'colorize'
end
